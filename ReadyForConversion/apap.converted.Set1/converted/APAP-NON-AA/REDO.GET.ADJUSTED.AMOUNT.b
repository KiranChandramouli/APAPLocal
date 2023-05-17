SUBROUTINE REDO.GET.ADJUSTED.AMOUNT(Y.PROP,BILL.ID,ADJ.AMOUNT)
*---------------------------------------------
* Description: This routine is to calculate the total adjusted amount for the Mora Charge.
*---------------------------------------------
* Input  Arg: Bill ID.
* Output Arg: Adjusted Amount.
*---------------------------------------------
* Date            Dev Ref        Resource            Comments
* 13 Aug 2012     CR-B4          H Ganesh            Initial Draft.
*---------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.BILL.DETAILS

    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN
*---------------------------------------------
OPEN.FILES:
*---------------------------------------------

    ADJ.AMOUNT = 0

    FN.AA.BILL.DETAILS = 'F.AA.BILL.DETAILS'
    F.AA.BILL.DETAILS  = ''
    CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)

RETURN
*---------------------------------------------
PROCESS:
*---------------------------------------------

    IF Y.PROP AND BILL.ID ELSE
        RETURN
    END

    CALL F.READ(FN.AA.BILL.DETAILS,BILL.ID,R.BILL.DETAILS,F.AA.BILL.DETAILS,BILL.ERR)
    LOCATE Y.PROP IN R.BILL.DETAILS<AA.BD.PROPERTY,1> SETTING PROP.POS THEN
        GOSUB GET.AMOUNT.ADJUSTED
    END
RETURN
*---------------------------------------------
GET.AMOUNT.ADJUSTED:
*---------------------------------------------
    Y.ADJUSTED.REF = R.BILL.DETAILS<AA.BD.ADJUST.REF,PROP.POS>
    Y.ADJUSTED.AMT = R.BILL.DETAILS<AA.BD.ADJUST.AMT,PROP.POS>
    Y.ADJUSTED.CNT = DCOUNT(Y.ADJUSTED.REF,@SM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.ADJUSTED.CNT
        Y.ADJUSTED.ID = Y.ADJUSTED.REF<1,1,Y.VAR1>
        Y.SECOND.PART = FIELD(Y.ADJUSTED.ID,'-',2)
        IF Y.SECOND.PART NE 'SUSPEND' THEN
            ADJ.AMOUNT += Y.ADJUSTED.AMT<1,1,Y.VAR1>
        END
        Y.VAR1 += 1
    REPEAT

RETURN
END
