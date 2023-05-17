SUBROUTINE REDO.BLD.USER.ACCT.SIGN(ENQ.DATA)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Riyas
*Program   Name    :REDO.BLD.USER.ACCT.SIGN
*---------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.USER
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.IM.DOCUMENT.IMAGE
    $INSERT I_System
    $INSERT I_F.ACCOUNT

    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

OPEN.FILES:
*----------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN

PROCESS:
*-------

    Y.ACCOUNT.ID = System.getVariable("CURRENT.ACCOUNT.NUM")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.ACCOUNT.ID = ""
    END

    LOCATE 'IMAGE.REFERENCE' IN ENQ.DATA<2,1> SETTING POS1 THEN
        CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
        IF R.ACCOUNT THEN
            ENQ.DATA<4,POS1> = Y.ACCOUNT.ID :' ':R.ACCOUNT<AC.CUSTOMER>
        END ELSE
            ENQ.DATA<4,POS1> = Y.ACCOUNT.ID
        END
    END ELSE
        CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
        IF R.ACCOUNT THEN
            ENQ.DATA<2,-1> = 'IMAGE.REFERENCE'
            ENQ.DATA<3,-1> = 'EQ'
            ENQ.DATA<4,-1> = Y.ACCOUNT.ID :' ':R.ACCOUNT<AC.CUSTOMER>
        END ELSE

            ENQ.DATA<2,-1> = 'IMAGE.REFERENCE'
            ENQ.DATA<3,-1> = 'EQ'
            ENQ.DATA<4,-1> = Y.ACCOUNT.ID
        END
    END

RETURN

END
