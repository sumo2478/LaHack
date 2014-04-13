from twisted.internet.protocol import Factory, Protocol
from twisted.internet import reactor

import json

import constants

from time import sleep

PORT = 23316

class IphoneChat(Protocol):
    def __init__(self):
        self.client_type = -1
        self.associated_client = None
        self.available = True
        self.m_id = -1
        self.name = "Collin Yen"

    def connectionMade(self):
        print "Client joined " + str(self)

    def connectionLost(self, reason):
        if self.client_type == constants.ENTITY_TYPE_EMPLOYEE:
            self.factory.employees.remove(self)
        elif self.client_type == constants.ENTITY_TYPE_CUSTOMER:
            if (self.associated_client):
                self.associated_client.available = True    

    def dataReceived(self, data):
        try:
            message = json.loads(data)
        except:
            print "Invalid json input " + str(data)
            return
        
        if (message['action'] == constants.ACTION_JOIN):
            self.handle_join(message)
        elif (message['action'] == constants.ACTION_MESSAGE):
            self.handle_message(message)
        elif (message['action'] == constants.ACTION_LEAVE):
            self.handle_leave(message)
        else:
            self.handle_error()

        print message

    def message(self, message):
        self.transport.write(message + '\n')

    def handle_join(self, message):
        self.m_id = message['id']
        response = {}

        # If the client is an employee
        if (message['entity_type'] == constants.ENTITY_TYPE_EMPLOYEE):
            self.client_type = constants.ENTITY_TYPE_EMPLOYEE
            self.factory.employees.append(self)

        # If the client is a customer
        elif (message['entity_type'] == constants.ENTITY_TYPE_CUSTOMER):
            self.client_type = constants.ENTITY_TYPE_CUSTOMER
            
            employee_found = False

            # Assign customer to a representative
            for employee in self.factory.employees:
                if (employee.available):
                    employee.associated_client = self
                    employee.available         = False
                    self.associated_client     = employee
                    employee_found             = True
                    break

            if (employee_found):
                print "Customer " + str(self.m_id) + " has joined"
                response['type'] = constants.SUCCESS
                response['message'] = "Connected with representative " + self.name
            else:
                print "No available employee"
                response['type'] = constants.ERROR
                response['message'] = "No customer service representative available"

            self.message(json.dumps(response))

    def handle_message(self, message):
        response = {}

        if (self.associated_client):
            response['type'] = constants.SUCCESS
            response['name'] = self.name
            response['message'] = message['message']
            self.associated_client.message(json.dumps(response))
        else:
            response['type'] = constants.ERROR
            response['message'] = "Client not conencted"
            self.message(json.dumps(response))


    def handle_leave(self, message):
        print "Handling leave"

    def handle_error(self):
        print "Handling error"

factory = Factory()
factory.protocol = IphoneChat
factory.employees = []
reactor.listenTCP(PORT, factory)
print "Iphone Chat server started " + str(PORT)

reactor.run()
