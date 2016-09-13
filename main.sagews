from sage.stats.distributions.discrete_gaussian_integer import DiscreteGaussianDistributionIntegerSampler
import numpy as np
import warnings
warnings.filterwarnings("ignore", category=DeprecationWarning)


#---------------------initialization------------------------------
n = 3
p = next_prime(n^2)
print "Modulo p is ",p
e_arbitrary = 5           #can be anything, it's arbitrary
m = floor(((1+e_arbitrary)*(n+1)*log(p)).n())
a_error = (1/(sqrt(n)*(log(n)^2))).n()

#-------------------private key construction-----------------------
s=vector(np.random.random_integers(0,p-1,n))

print "Private key is ",s

#--------------------public key contruction---------------------------------
a = matrix(m,n)
for i in range(m):
    a[i] = vector(np.random.random_integers(0,p-1,n)) #those are the public key vectors
sigma = a_error*p                                     #standard deviation  is a*q
D = DiscreteGaussianDistributionIntegerSampler(sigma=sigma) #the Ψa(n) distribution 
e = [Mod(D(),p) for _ in xrange(m)]     #error offsets
PK = matrix(m,n+1)                      #last column will be the b
for i in range(m):
    for j in range(n):
            PK[i,j] = a[i,j]
    PK[i,n] = Mod(Mod(a[i].inner_product(s),p)+e[i],p)
print "Public Key is: ",PK

#ENCRYPTION--------------------------------------------
#Message to binary
Amessage="A message"
Message=' '.join(format(ord(x), 'b') for x in Amessage)
Messagelength=len(Message)

#EncryptedMessage matrix initialization
EncryptedMessage=matrix(Messagelength,n+1)

#Encryption Proccess
for i in range(Messagelength):
    #Random size of random set S
    Ssize=int(random()*(m+1))
    print "The number of elements of random set S of %d bit is:"%i,Ssize

    #Random Set S initilization
    S=matrix(Ssize,n+1)

    #This list counts the times a random row of Public Key is chosen to be entered in S.
    counter=[0 for ci in range(m)]

    #Random rows of Public Key are entered in S.
    for ci in range(Ssize):
        rand=int(random()*(m))
        counter[rand]+=1
        #No duplicate rows
        if counter[rand]<2:
    	    for l in range(n+1):
    	        S[ci,l]=PK[rand,l]
    print "Random Set is: ",S
    print "----------------------"
    for k in range(n+1):
        for j in range(Ssize):
            #In each column of EncryptedMessage, the sum of A parameters of each of column of S is entered,except for the last one
                EncryptedMessage[i,k]+=Mod(S[j,k],p)
    if Message[i]==1:
        EncryptedMessage[i,n]=Mod(EncryptedMessage[i,n]+floor(p/2),p)
    print EncryptedMessage
