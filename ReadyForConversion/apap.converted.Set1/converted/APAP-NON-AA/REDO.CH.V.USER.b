SUBROUTINE REDO.CH.V.USER
**
* Subroutine Type : VERSION
* Attached to     : PASSWORD.RESET,REDO.CH.RESUSRPWD
* Attached as     : USER.RESET field as VALIDATION.RTN
* Primary Purpose : Reset to a new temporal password to be sent by email to
*                   Internet User by email.
*-----------------------------------------------------------------------------
* MODIFICATIONS HISTORY
*
* 1/11/10 - First Version.
*           ODR Reference: ODR-2010-06-0155.
*           Project: NCD Asociacion Popular de Ahorros y Prestamos (APAP).
*           Martin Macias.
*           mmacias@temenos.com
* 07/11/11 - Fix for PACS00146411.
*            Roberto Mondragon - TAM Latin America.
*            rmondragon@temenos.com
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.PASSWORD.RESET
    $INSERT I_F.EB.EXTERNAL.USER
    $INSERT I_F.CUSTOMER

    IF R.NEW(EB.PWR.USER.RESET) EQ '' THEN
        RETURN
    END

    GOSUB INIT
    GOSUB PROCESS

RETURN

********
PROCESS:
********

    ID.USER = R.NEW(EB.PWR.USER.RESET)

    R.EXT.USER = ''; EXUSER.ERR = ''
    CALL CACHE.READ(FN.EXT.USER, ID.USER, R.EXT.USER, EXUSER.ERR)
    IF R.EXT.USER THEN
        ID.CUS = R.EXT.USER<EB.XU.CUSTOMER>
        USER.STATUS = R.EXT.USER<EB.XU.STATUS>
    END

    IF R.EXT.USER<EB.XU.CHANNEL> NE "INTERNET" THEN
        E = "EB-REDO.CHANN.INTERNET"
        RETURN
    END

    IF USER.STATUS NE 'ACTIVE' THEN
        E = "EB-REDO.CH.USR.NO.ACTIVE"
        RETURN
    END

    R.CUSTOMER = ''; CUS.ERR = ''
    CALL F.READ(FN.CUST,ID.CUS,R.CUSTOMER,FV.CUST,CUS.ERR)
    IF R.CUSTOMER EQ '' THEN
        E = "EB-CUSTOMER.NOT.EXIST"
        RETURN
    END

RETURN

*****
INIT:
*****

    FN.CUST = 'F.CUSTOMER'
    FV.CUST = ''
    CALL OPF(FN.CUST, FV.CUST)

    FN.EXT.USER = 'F.EB.EXTERNAL.USER'
    FV.EXT.USER = ''
    CALL OPF(FN.EXT.USER, FV.EXT.USER)

RETURN

END
