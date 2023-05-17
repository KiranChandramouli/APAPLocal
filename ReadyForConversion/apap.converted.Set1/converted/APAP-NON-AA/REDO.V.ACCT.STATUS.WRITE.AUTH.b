SUBROUTINE REDO.V.ACCT.STATUS.WRITE.AUTH
* ----------------------------------------------------------------------------------------------
* Company Name     : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By     : Temenos India Pvt Ltd
* Author           : Gopala Krishnan R
* Development Id   : PACS00682620_2660842
* Date             : 17-JUL-2018
*----------------------------------------------------------------------------------------------
* Subroutine Type  : Auth Routine
* Attached to      : VERSION > TELLER,REDO.ACCOUNT.CLOSURE.ML
*
*
* Attached As      : Auth Routine
* ----------------------------------------------------------------------------------------------
* Primary Purpose  : This is an AUTHORISATION routine to update ACCOUNT.STATUS on ACCOUNT.CLOSURE application.
*
* ----------------------------------------------------------------------------------------------
* ARGS -(Input)    : N/A
* ARGS -(Output)   : N/A
* ----------------------------------------------------------------------------------------------
* Modification History:
* ---------------------
* Modification Ref :
* Modification Date:
* Modified by      :
* Modifi. Descript :
*----------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.ACCOUNT.CLOSURE

    GOSUB INIT
    GOSUB PROCESS

RETURN

*---------------------------------------------------------------------------------
INIT:
*---------------------------------------------------------------------------------


    FN.ACCOUNT.CLOSURE ='F.ACCOUNT.CLOSURE'
    F.ACCOUNT.CLOSURE =''
    CALL OPF(FN.ACCOUNT.CLOSURE,F.ACCOUNT.CLOSURE)

    Y.APPL.1 = 'ACCOUNT.CLOSURE'
    Y.FIELD.1 = 'L.TT.AC.STATUS'
    Y.POS.1 = ''
    CALL GET.LOC.REF(Y.APPL.1,Y.FIELD.1,Y.POS.1)

    Y.APPL.2 = 'TELLER'
    Y.FIELD.2 = 'L.TT.AZ.ACC.REF'
    Y.POS.2 = ''
    CALL GET.LOC.REF(Y.APPL.2,Y.FIELD.2,Y.POS.2)

RETURN

*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

    Y.ACCT = R.NEW(TT.TE.LOCAL.REF)<1,Y.POS.2>
    CALL F.READ(FN.ACCOUNT.CLOSURE,Y.ACCT,R.ACCOUNT.CLOSURE,F.ACCOUNT.CLOSURE,ACCOUNT.CLOSURE.ERR)
    ACCT.STATUS = R.ACCOUNT.CLOSURE<AC.ACL.LOCAL.REF,Y.POS.1>

    IF ACCT.STATUS EQ "" THEN
        ACCT.STATUS = "CLOSED"
        R.ACCOUNT.CLOSURE<AC.ACL.LOCAL.REF,Y.POS.1> = ACCT.STATUS
        CALL F.WRITE(FN.ACCOUNT.CLOSURE,Y.ACCT,R.ACCOUNT.CLOSURE)
    END

RETURN

END
