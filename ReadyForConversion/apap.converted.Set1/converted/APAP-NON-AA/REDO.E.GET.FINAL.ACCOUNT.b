SUBROUTINE REDO.E.GET.FINAL.ACCOUNT(ENQ.DATA)
************************************************************
*----------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : JEEVA T
* Program Name : REDO.E.GET.FINAL.ACCOUNT
*----------------------------------------------------------

* Description   :
* Linked with   :
* In Parameter  : None
* Out Parameter : None
*----------------------------------------------------------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*10.10.2010   SHANKAR RAJU  ODR-2010-08-0031   INITIAL CREATION
*10.04.2017   SIMBU           PACS00585729
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.CLOSE.ACCT
    $INSERT I_EB.EXTERNAL.COMMON

    GOSUB OPEN
    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------
OPEN:
*---

    FN.REDO.CLOSE.ACCT ='F.REDO.CLOSE.ACCT'
    F.REDO.CLOSE.ACCT  = ''
    R.REDO.CLOSE.ACCT  = ''
    CALL OPF(FN.REDO.CLOSE.ACCT,F.REDO.CLOSE.ACCT)

    FN.REDO.ACCT.EXCE.RBHP = 'F.REDO.ACCT.EXCE.RBHP'
    F.REDO.ACCT.EXCE.RBHP = ''
    CALL OPF(FN.REDO.ACCT.EXCE.RBHP,F.REDO.ACCT.EXCE.RBHP)

    Y.ID = 'ACCOUNT.CLOSURE-':ID.COMPANY
    SEL.RBHP.LIST = '' ; ERR.RBHP.CUS = '' ; R.REDO.ACCT.EXCE.RBHP = ''
    SEL.CUS.CMD = 'SELECT ':FN.REDO.ACCT.EXCE.RBHP:' WITH @ID LIKE ':Y.ID:'...'
    CALL EB.READLIST(SEL.CUS.CMD,SEL.RBHP.LIST,'',NO.OF.REC,ERR.RBHP.CUS)
    IF SEL.RBHP.LIST THEN
        LOOP
            REMOVE Y.RBHP.ID FROM SEL.RBHP.LIST SETTING RBHP.POS
        WHILE Y.RBHP.ID:RBHP.POS
            R.REDO.ACCT.EXCE.RBHP<-1> = FIELD(Y.RBHP.ID,'-',3)
        REPEAT
    END


RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
* This part is added to display branchwise account numbers
*Y.FILE.NAME = 'ACCOUNT.CLOSURE'
*CURRNT.COMP = ID.COMPANY
*Y.ID = Y.FILE.NAME:'-':CURRNT.COMP
*CALL F.READ(FN.REDO.ACCT.EXCE.RBHP,Y.ID,R.REDO.ACCT.EXCE.RBHP,F.REDO.ACCT.EXCE.RBHP,ERR.RBHP)

    LOCATE 'ACCOUNT.NUMBER' IN ENQ.DATA<2,1> SETTING POS1 THEN
        ENQ.DATA<2,POS1> = "@ID"
        Y.ACCOUNT = ENQ.DATA<4,POS1>
    END ELSE
        POS1=''
    END

    IF Y.ACCOUNT THEN
        CALL F.READ(FN.REDO.CLOSE.ACCT,Y.ACCOUNT,R.REDO.CLOSE.ACCT,F.REDO.CLOSE.ACCT,ERR.ACC.CONC)
        IF R.REDO.CLOSE.ACCT THEN
            IF R.REDO.CLOSE.ACCT<REDO.ACCT.LIQ.ACCOUNT> NE '' THEN
                Y.ACCOUNT        = R.REDO.CLOSE.ACCT<REDO.ACCT.LIQ.ACCOUNT>
                ENQ.DATA<4,POS1> = Y.ACCOUNT
            END
        END
        LOCATE Y.ACCOUNT IN R.REDO.ACCT.EXCE.RBHP SETTING POS.L ELSE
* ENQ.DATA<4,POS1> = 'ZZZZZ'
        END
    END ELSE
        R.REDO.ACCT.EXCE.RBHP = CHANGE(R.REDO.ACCT.EXCE.RBHP,@FM,@SM)
        ENQ.DATA<2,-1> = "@ID"
        ENQ.DATA<3,-1> = "EQ"
        ENQ.DATA<4,-1> = R.REDO.ACCT.EXCE.RBHP
    END

RETURN
*-----------------------------------------------------------------------------
END
