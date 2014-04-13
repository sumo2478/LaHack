from twisted.internet.protocol import Factory, Protocol
from twisted.internet import reactor

import json
import constants
import MySQLdb
from urllib import urlencode
from urllib2 import urlopen


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
        print "Connection lost"
        if self.client_type == constants.ENTITY_TYPE_EMPLOYEE:
            self.factory.employees.remove(self)
            print "Employee " + str(self.m_id) + " disconnected"
        elif self.client_type == constants.ENTITY_TYPE_CUSTOMER:
            if (self.associated_client):
                self.associated_client.available = True    
            print "Customer " + str(self.m_id) + " disconnected"

    def dataReceived(self, data):
        try:
            message = json.loads(data)

            if (message['action'] == constants.ACTION_JOIN):
                self.handle_join(message)
            elif (message['action'] == constants.ACTION_MESSAGE):
                self.handle_message(message)
            elif (message['action'] == constants.ACTION_LEAVE):
                self.handle_leave(message)
            else:
                self.handle_error()
        except:
            print "Invalid json input " + str(data)
            return

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

            # Retrieve name for employee
            db = MySQLdb.connect(host="localhost", user="root", passwd="customer", db="LaHacks")
            cursor = db.cursor()

            cursor.execute("SELECT name FROM Employees WHERE id = %s", self.m_id)
            db.commit()

            row = cursor.fetchone()
            self.name = row[0]
        
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
            print "Score: "
            self.getScore(message['message'])
        else:
            response['type'] = constants.ERROR
            response['message'] = "Client not conencted"
            self.message(json.dumps(response))

    def handle_error(self):
        print "Handling error"

    def getScore(self, text):
        url = "https://api.sentigem.com/external/get-sentiment"
        api_key = "6352f666047a4a30aa8f346d7793d5296Twn2FfkboMSWjt9OYg5PyAJG7v8BK1q"
        search_url = [url, '?']
        args = {'api-key': api_key, 'text':text}

        search_url.append(urlencode(args))
        data = json.loads(urlopen(''.join(search_url)).read())
        print str(data)


factory = Factory()
factory.protocol = IphoneChat
factory.employees = []
reactor.listenTCP(PORT, factory)
print "Iphone Chat server started " + str(PORT)

reactor.run()
