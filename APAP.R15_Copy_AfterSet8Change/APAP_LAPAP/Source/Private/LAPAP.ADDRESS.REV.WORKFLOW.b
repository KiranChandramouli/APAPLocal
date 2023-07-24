$PACKAGE APAP.LAPAP
* Item ID        : CN009003
*-------------------------------------------------------------------------------------
* Description :
* ------------
*This program allows to continue the reverse of the transaction, once the user justifies the reverse through the correct version
*-------------------------------------------------------------------------------------
* Modification History :
* ----------------------
* Date           Author            Modification Description
* -------------  -----------       ---------------------------
* 2018/06/29     Raquel P.S.         Initial development
*-------------------------------------------------------------------------------------
* Content summary :
* -----------------
* Versions  : ST.L.REVERSE.TXN.JUSTIFY,INPUT
* EB record : LAPAP.ADDRESS.REV.WORKFLOW
*-------------------------------------------------------------------------------------


SUBROUTINE LAPAP.ADDRESS.REV.WORKFLOW
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 13-JULY-2023      Harsha                R22 Auto Conversion  - Changes = to EQ
* 13-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_F.ST.L.REVERSE.TXN.JUSTIFY

    FN.ST.L.REVERSE.TXN.JUSTIFY = "F.ST.L.REVERSE.TXN.JUSTIFY"
    F.ST.L.REVERSE.TXN.JUSTIFY = ""

    CALL OPF(FN.ST.L.REVERSE.TXN.JUSTIFY,F.ST.L.REVERSE.TXN.JUSTIFY)


***Get the name of the previous Enquiry and next version.
***-----------------------------------------------------------------

    Y.ID.TXN=ID.NEW
    Y.CURRENT.ENQ=R.NEW(ST.L.R84.NAME.ENQUIRY)
    Y.CURRENT.VER=R.NEW(ST.L.R84.VERSION.ACT)
    Y.CURRENT.TRANS.REF= R.NEW(ST.L.R84.TRANS.REFERENCE)
    Y.FUNCTION.REV= ' R '

***Evaluate the initial enquiry to invoke next version
***-----------------------------------------------------------------

    BEGIN CASE
        CASE Y.CURRENT.ENQ EQ "REDO.REV.TRANS.NV.CHAIN"
            NEW.TASK ='ENQ REDO.DEL.CHAIN @ID EQ ': Y.ID.TXN
            GOSUB CALL.ENQUIRY

        CASE Y.CURRENT.ENQ EQ "REDO.TELLER.TODAY"
            NEW.TASK = Y.CURRENT.VER : Y.FUNCTION.REV : Y.ID.TXN
            GOSUB CALL.ENQUIRY

        CASE Y.CURRENT.ENQ EQ "REDO.TFS.REVERSAL"
            NEW.TASK = 'T24.FUND.SERVICES,LCY.COLLECT.REV I ': Y.ID.TXN
            GOSUB CALL.ENQUIRY

        CASE Y.CURRENT.ENQ EQ "REDO.REVERSE.DRAWN.CHQ"
            NEW.TASK = 'FUNDS.TRANSFER,REDO.REVERSE.CHQ I F3'
            GOSUB CALL.ENQUIRY

        CASE Y.CURRENT.ENQ EQ "REDO.REVERSE.CASH.CHQ"
            NEW.TASK = Y.CURRENT.VER : Y.FUNCTION.REV : Y.CURRENT.TRANS.REF
            GOSUB CALL.ENQUIRY


    END CASE
RETURN


***-------------***
CALL.ENQUIRY:
***-------------***

    CALL EB.SET.NEW.TASK(NEW.TASK)
    Y.CURRENT.ENQ=''
    Y.FUNCTION.REV=''
    Y.CURRENT.TRANS.REF=''
    NEW.TASK=''

RETURN

END
