$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.BLD.AC.CONSOL(ENQ.DATA)

****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : MANJAMMA DEVI.G
* Program Name  : REDO.E.BLD.AC.CONSOL
*-------------------------------------------------------------------------

* Description : This BUILD routine REDO.E.BLD.AC.CONSOL will be executed
* during ENQUIRY SELECTION. It will monitor the customer name and currency
* of the new deposit account.Get the customer id and all AZ.ACCOUNT  for that
* customer with the currency corresponding to the new deposit account.Now it
* extracts the principal amount of the valid customer and add the amount of the
* new deposit with the corresponding balance of the other accounts.Thus it
*  provides the updated balance consolidation

* In parameter : None
* out parameter : None
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 10-APRIL-2023      Conversion Tool       R22 Auto Conversion - FM to @FM and ++ to +=
* 10-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
*-------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ENQUIRY
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.AZ.CUSTOMER

MAIN:

    GOSUB INIT
    GOSUB OPENFILE
    GOSUB PROCESS
RETURN

INIT:
    FN.AZ.CUSTOMER = 'F.AZ.CUSTOMER'
    F.AZ.CUSTOMER = ''
    Y.AZ.CUSTOMER.ID = ''
    Y.ACCOUNT.CURRENCY = ''
    Y.SEL.CURRENCY = ''
    ER.AZ.CUSTOMER = ''
    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    ER.AZ.ACCOUNT = ''
    Y.ARRAY =""
    Y.JOINT.NUM=''
RETURN

OPENFILE:
    CALL OPF(FN.AZ.CUSTOMER,F.AZ.CUSTOMER)
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.JOINT.CONTRACTS.XREF='F.JOINT.CONTRACTS.XREF'
    F.JOINT.CONTRACTS.XREF=''
    CALL OPF(FN.JOINT.CONTRACTS.XREF,F.JOINT.CONTRACTS.XREF)

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN

PROCESS:



    LOCATE '@ID' IN ENQ.DATA<2,1> SETTING Y.POS THEN
        RETURN
    END
    LOCATE "CUSTOMER" IN ENQ.DATA<2,1> SETTING Y.POS THEN
        Y.AZ.CUSTOMER.ID = ENQ.DATA<4,Y.POS>
    END
    LOCATE "CURRENCY" IN ENQ.DATA<2,1> SETTING Y.POS THEN
        Y.SEL.CURRENCY = ENQ.DATA<4,Y.POS>
    END

    R.AZ.CUSTOMER=''
    CALL F.READ(FN.AZ.CUSTOMER,Y.AZ.CUSTOMER.ID,R.AZ.CUSTOMER,F.AZ.CUSTOMER,ER.AZ.CUSTOMER)
    GOSUB GET.JOINT.HOLDER
    LOOP
        REMOVE Y.AZ.ACCOUNT.ID FROM R.AZ.CUSTOMER SETTING Y.ACCOUNT.POS
    WHILE Y.AZ.ACCOUNT.ID:Y.ACCOUNT.POS
        R.AZ.ACCOUNT=''
        IF Y.AZ.ACCOUNT.ID EQ '' THEN
            CONTINUE
        END
        CALL F.READ(FN.AZ.ACCOUNT,Y.AZ.ACCOUNT.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,ER.AZ.ACCOUNT)
        Y.ACCOUNT.CCY = R.AZ.ACCOUNT<AZ.CURRENCY>
        IF Y.SEL.CURRENCY EQ Y.ACCOUNT.CCY THEN
            Y.ARRAY<-1>=Y.AZ.ACCOUNT.ID
        END
    REPEAT

    CHANGE @FM TO " " IN Y.ARRAY

    ENQ.DATA<2> = "@ID"
    ENQ.DATA<3> = "EQ"
    ENQ.DATA<4> = Y.ARRAY

RETURN
*-------------------------------------------------------------------------
GET.JOINT.HOLDER:
*-------------------------------------------------------------------------

    CALL F.READ(FN.JOINT.CONTRACTS.XREF,Y.AZ.CUSTOMER.ID,R.JOINT.CONTRACTS.XREF,F.JOINT.CONTRACTS.XREF,XREF.ERR)
    NO.OF.JOINT.ACCOUNT=DCOUNT(R.JOINT.CONTRACTS.XREF,@FM)
    Y.VAR1=1
    LOOP
    WHILE Y.VAR1 LE NO.OF.JOINT.ACCOUNT
        Y.ACC.NO=R.JOINT.CONTRACTS.XREF<Y.VAR1>
        CALL F.READ(FN.ACCOUNT,Y.ACC.NO,R.ACC,F.ACCOUNT,ACC.ERR)
        Y.JOINT.HOLD=R.ACC<AC.JOINT.HOLDER>
        LOCATE Y.AZ.CUSTOMER.ID IN Y.JOINT.HOLD<1,1> SETTING POS1 THEN
            Y.RELATION.CODE=R.ACC<AC.RELATION.CODE,POS1>
            IF (Y.RELATION.CODE GE 500 AND Y.RELATION.CODE LE 509) OR (Y.RELATION.CODE GE 600 AND Y.RELATION.CODE LE 609) THEN
                R.AZ=''
                CALL F.READ(FN.AZ.ACCOUNT,Y.ACC.NO,R.AZ,F.AZ.ACCOUNT,AZ.ERR)
                IF R.AZ NE '' THEN
                    Y.JOINT.NUM<-1>=Y.ACC.NO
                END
            END
        END
        Y.VAR1 += 1
    REPEAT
    R.AZ.CUSTOMER=R.AZ.CUSTOMER:@FM:Y.JOINT.NUM

RETURN

END
