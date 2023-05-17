SUBROUTINE REDO.RAD.MON.CUSTID.OPER

*-----------------------------------------------------------------------------
* Primary Purpose: Returns identification and identification type of a customer given as parameter
* Used in RAD.CONDUIT.LINEAR as API routine.
* Input Parameters: CUSTOMER.CODE
* Output Parameters: Identification @ Identification type
*-----------------------------------------------------------------------------
* Modification History:
*
* 18/09/10 - Cesar Yepez
* New Development
* 12-OCT-2017 - Gopala Krishnan R
* PACS00623823
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_TSS.COMMON

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN
*-----------------------------------------------------------------------------------
PROCESS:
    CALL F.READ(FN.CUSTOMER, Y.CUST.CODE, R.CUSTOMER, F.CUSTOMER, ERR.CUS)

    IF NOT(ERR.CUS) THEN
        Y.LEGAL.ID = R.CUSTOMER<EB.CUS.LEGAL.ID>
        Y.L.CU.CIDENT = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.POS.CIDENT>
*PACS00623823 - S
        Y.L.CU.NOUNICO = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.POS.NOUNICO>
*PACS00623823 - E

        BEGIN CASE
            CASE Y.LEGAL.ID NE ''
                Y.RETURN = Y.LEGAL.ID : Y.DELIMITER : Y.PASSPORT.IDENTIF
            CASE Y.L.CU.CIDENT NE ''
                Y.RETURN = Y.L.CU.CIDENT : Y.DELIMITER : Y.CEDULA.IDENTIF
*PACS00623823 - S
            CASE Y.L.CU.NOUNICO NE ''
                Y.RETURN = Y.L.CU.NOUNICO : Y.DELIMITER : Y.CEDULA.IDENTIF
*PACS00623823 - E
        END CASE

    END

    COMI = Y.RETURN

RETURN
*-----------------------------------------------------------------------------------

*-----------------------------------------------------------------------------------

*//////////////////////////////////////////////////////////////////////////////////*
*////////////////P R E P R O C E S S S U B R O U T I N E S //////////////////////*
*//////////////////////////////////////////////////////////////////////////////////*
INITIALISE:
    PROCESS.GOAHEAD = 1
    IP.ADDRESS = TSS$CLIENTIP
    Y.INTERF.ID = 'MON001'
    Y.RETURN = ''
    Y.CEDULA.IDENTIF = 'CED'
    Y.PASSPORT.IDENTIF = 'PAS'
    ERR.MSG = ''
    ERR.TYPE = ''
    Y.LEGAL.ID = ''
    Y.L.CU.CIDENT = ''
    Y.L.CU.NOUNICO = ''
    Y.DELIMITER = '@'
    CALL GET.LOC.REF("CUSTOMER","L.CU.CIDENT", Y.POS.CIDENT)
    CALL GET.LOC.REF("CUSTOMER","L.CU.NOUNICO", Y.POS.NOUNICO)
    Y.CUST.CODE = COMI


RETURN
*-----------------------------------------------------------------------------------

OPEN.FILES:
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

RETURN

*-----------------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:

RETURN

*-----------------------------------------------------------------------------------

END
