SUBROUTINE REDO.DS.GET.USER.LOGIN(VAR.USER.COMP.DESC)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :S SUDHARSANAN
*Program   Name    :REDO.DS.GET.BENEF.NAME
*---------------------------------------------------------------------------------
* DESCRIPTION       :This program is used to get the account title value
* ----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT.CLOSURE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_System
    $INSERT I_F.COMPANY

    GOSUB PROCESS

RETURN

*********
PROCESS:
**********
    FN.COMPANY = 'F.COMPANY'
    F.COMPANY = ''
    CALL OPF(FN.COMPANY,F.COMPANY)


    CURRENT.COMP = System.getVariable("CURRENT.USER.BRANCH")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        CURRENT.COMP = ""
    END
    IF CURRENT.COMP EQ "CURRENT.USER.BRANCH" THEN
        LOCATE 'EB-UNKNOWN.VARIABLE' IN E<1,1> SETTING POS THEN
            E = ''
        END
        RETURN
    END
    VAR.USER.LOGIN = CURRENT.COMP

    CALL CACHE.READ(FN.COMPANY, VAR.USER.LOGIN, R.COMP, COMP.ERR)

    VAR.USER.COMP.DESC = R.COMP<EB.COM.COMPANY.NAME,LNGG>

    IF NOT(VAR.USER.COMP.DESC) THEN
        VAR.USER.COMP.DESC = R.COMP<EB.COM.COMPANY.NAME,1>
    END

RETURN
*-----------------
END
