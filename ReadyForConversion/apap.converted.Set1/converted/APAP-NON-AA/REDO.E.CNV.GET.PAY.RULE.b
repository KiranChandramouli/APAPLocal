SUBROUTINE REDO.E.CNV.GET.PAY.RULE
************************************************************
*----------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Description   : This subroutine is attached as a conversion routine in the Enquiry REDO.E.AA.ARR.ACTIVITY
*                 to get the old properrty list
* Linked with   : Enquiry REDO.E.AA.ARR.ACTIVITY  as conversion routine
* In Parameter  : None
* Out Parameter : None
*-----------------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*10.07.2010  PRABHU N      ODR-2010-08-0017   INITIAL CREATION
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.PAYMENT.RULES
    $INSERT I_System
    GOSUB INITIALISE
    GOSUB READ.AND.ASSIGN

RETURN

*----------------------------------------------------------------
INITIALISE:
*----------------------------------------------------------------

    FN.AA.ARR.PAYMENT.RULES='F.AA.ARR.PAYMENT.RULES'
    F.AA.ARR.PAYMENT.RULES=''
    CALL OPF(FN.AA.ARR.PAYMENT.RULES,F.AA.ARR.PAYMENT.RULES)
    Y.AA.ARR.ID= O.DATA
    Y.AA.ID=FIELD(Y.AA.ARR.ID,'-',1)
RETURN


*-----------------------------------------------------------------
READ.AND.ASSIGN:
*-----------------------------------------------------------------

    VAR.SEL.PAY.RULE="SELECT  ":FN.AA.ARR.PAYMENT.RULES:" WITH @ID LIKE ":Y.AA.ID:"..."
    CALL EB.READLIST(VAR.SEL.PAY.RULE,VAR.ID.LIST,'',R.RECORD.COUNT,ERR)
    LOCATE Y.AA.ARR.ID IN VAR.ID.LIST SETTING VAR.PAY.RULE.POS THEN
    END
    VAR.AA.PAY.ID=VAR.ID.LIST<VAR.PAY.RULE.POS-1>
    CALL F.READ(FN.AA.ARR.PAYMENT.RULES,VAR.AA.PAY.ID,R.PAY.RULE,F.AA.ARR.PAYMENT.RULES,ERR)
    IF VC EQ 1 THEN
*AA CHANGES 20161013
*    Y.OD = R.PAY.RULE<AA.PAYRULE.PROPERTY>
        Y.OD = R.PAY.RULE<AA.PAYRULE.PROPERTY,1,1>
*AA CHANGES 20161013
        CALL System.setVariable("CURRENT.MUL.FIELD",Y.OD)
        VM.COUNT = DCOUNT(Y.OD,@VM)
        O.DATA = Y.OD<1,VC>
    END ELSE
        Y.SINGLE.VALUE=System.getVariable("CURRENT.MUL.FIELD")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN
            Y.SINGLE.VALUE = ""
        END
        O.DATA = Y.SINGLE.VALUE<1,VC>
    END
RETURN
END
