SUBROUTINE REDO.COS.RTN

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    GOSUB INIT
    GOSUB PROCESS

RETURN

INIT:
*****

    COS.NAME=''

    Y.APPLICATION = FIELD(O.DATA,'*',1)
    Y.CUST.ID = FIELD(O.DATA,'*',2)
    Y.ACCT.ID = FIELD(O.DATA,'*',3)
    Y.COS = "COS"
RETURN

PROCESS:
********

    BEGIN CASE
        CASE Y.APPLICATION EQ "ACC"
*COS.NAME = Y.COS:' ':'REDO.AC.COS':' ':Y.CUST.ID ;*// WK 12JAN2012
            COS.NAME = Y.COS:' ':'REDO.AC.COS':' ':Y.CUST.ID:' ':Y.ACCT.ID
        CASE Y.APPLICATION EQ "AZ"
            COS.NAME = Y.COS:' ':'REDO.AZ.COS':' ':Y.ACCT.ID
        CASE Y.APPLICATION EQ 'MM'
*COS.NAME = 'MM.MONEY.MARKET S ' :Y.ACCT.ID
            COS.NAME = Y.COS:' ':'REDO.MM.COS':' ':Y.ACCT.ID
    END CASE

    O.DATA = COS.NAME

RETURN
END
