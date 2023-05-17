SUBROUTINE REDO.NOFILE.INACTIVATE.LIST(FIN.ARR)
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By :
* Program Name : REDO.NOFILE.INACTIVATE.LIST
*-----------------------------------------------------------------------------
* Description : This subroutine is attached as a BUILD routine in the Enquiry REDO.SAV.ACCOUNT.LIST
* Linked with : Enquiry REDO.SAV.ACCOUNT.LIST  as BUILD routine
* In Parameter : ENQ.DATA
* Out Parameter : None
*
**DATE           ODR                   DEVELOPER               VERSION
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System
    $INSERT I_EB.EXTERNAL.COMMON
    $INSERT I_F.EB.EXTERNAL.USER
    GOSUB INITIALISE
    GOSUB FORM.ACCT.ARRAY

RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    FN.EB.EXTERNAL.USER = 'F.EB.EXTERNAL.USER'
    F.EB.EXTERNAL.USER = ''
    CALL OPF(FN.EB.EXTERNAL.USER,F.EB.EXTERNAL.USER)

    FN.CORPORATE.USER.LIST = 'F.CORPORATE.USER.LIST'
    F.CORPORATE.USER.LIST  = ''
    CALL OPF(FN.CORPORATE.USER.LIST,F.CORPORATE.USER.LIST)

    LOC.REF.FIELDS      = 'PROD.USED'
    LOC.REF.POS         = ''
    LOC.REF.APPLICATION = 'EB.EXTERNAL.USER'

    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)

    POS.PROD.USED = LOC.REF.POS<1,1>

    CUSTOMER.ID = System.getVariable('EXT.SMS.CUSTOMERS')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        CUSTOMER.ID = ""
    END

    FIN.ARR = ''

RETURN
******************
FORM.ACCT.ARRAY:
*****************

    CALL F.READ(FN.CORPORATE.USER.LIST,CUSTOMER.ID,R.CORPORATE.USER.LIST,F.CORPORATE.USER.LIST,CORPORATE.USER.LIST.ERR)

    LOOP
        REMOVE Y.EXT.USER.ID FROM R.CORPORATE.USER.LIST SETTING EXT.POS
    WHILE Y.EXT.USER.ID:EXT.POS
        CALL CACHE.READ(FN.EB.EXTERNAL.USER, Y.EXT.USER.ID, R.EB.EXTERNAL.USER, EB.EXTERNAL.USER.ERR)
        IF R.EB.EXTERNAL.USER THEN
            Y.EXT.STATUS = R.EB.EXTERNAL.USER<EB.XU.STATUS>
            Y.EX.NAME  = R.EB.EXTERNAL.USER<EB.XU.NAME>
            Y.CNT.DATE.LAST.USE = DCOUNT(R.EB.EXTERNAL.USER<EB.XU.DATE.LAST.USE>,@SM)

            Y.EX.DATE.LAST.USE = R.EB.EXTERNAL.USER<EB.XU.DATE.LAST.USE,1,1>
            Y.CNT.TIME.LAST.USE = DCOUNT(R.EB.EXTERNAL.USER<EB.XU.TIME.LAST.USE>,@SM)

            Y.EX.TIME.LAST.USE = R.EB.EXTERNAL.USER<EB.XU.TIME.LAST.USE,1,1>
            Y.PROD.USED =   R.EB.EXTERNAL.USER<EB.XU.LOCAL.REF,POS.PROD.USED>

            BEGIN CASE
                CASE Y.PROD.USED  EQ 'CORPADMIN'
                    Y.ROLE  = 'ADMINISTRATOR'
                CASE Y.PROD.USED  EQ 'CORPAUTH'
                    Y.ROLE  = 'AUTHORIZER'
                CASE Y.PROD.USED  EQ 'CORPINPUT'
                    Y.ROLE  = 'INPUTTER'
            END CASE

            IF Y.EX.TIME.LAST.USE THEN
                Y.EX.TIME.LAST.USE = Y.EX.TIME.LAST.USE[1,2]:':':Y.EX.TIME.LAST.USE[3,2]:':':Y.EX.TIME.LAST.USE[5,2]
            END

        END
        IF Y.EXT.STATUS EQ 'ACTIVE' THEN
            FIN.ARR<-1> = Y.EXT.USER.ID:'@':Y.EX.NAME:'@':Y.EX.DATE.LAST.USE:'@':Y.EX.TIME.LAST.USE:'@':Y.ROLE
        END
    REPEAT

RETURN
END
*---------------------------*END OF SUBROUTINE*-------------------------------
