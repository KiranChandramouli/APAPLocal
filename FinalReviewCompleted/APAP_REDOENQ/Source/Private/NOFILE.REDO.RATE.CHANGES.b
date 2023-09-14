* @ValidationCode : Mjo0NjgwMzQ2NDI6Q3AxMjUyOjE2ODU1NDMwOTU5MzI6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 May 2023 19:54:55
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE NOFILE.REDO.RATE.CHANGES(Y.RETURN.ARRAY)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This is the nofile routine
*
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*---------------
*-----------------------------------------------------------------------------
* Modification History :
*   Date            Who            Reference            Description
* 01-JUL-2010    Kishore.SP     ODR-2009-10-0325      Initial Creation
*  DATE             WHO                   REFERENCE
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion - ! to *
* 06-APRIL-2023      Harsha                R22 Manual Conversion - Call rtn modified
*------------------------------------------------------------------------
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.PRODUCT
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.INTEREST
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.SUCESS.RATE.CHANGE
    $USING APAP.TAM
    $USING APAP.AA
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB LOCATE.VALUES
    GOSUB SELECT.CMD
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------
*
    FN.AA.ARR.INTEREST = 'F.AA.ARR.INTEREST'
    F.AA.ARR.INTEREST = ''
    CALL OPF(FN.AA.ARR.INTEREST,F.AA.ARR.INTEREST)
*
    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
*
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
*
    FN.REDO.SUCESS.RATE.CHANGE = 'F.REDO.SUCESS.RATE.CHANGE'
    F.REDO.SUCESS.RATE.CHANGE  = ''
    CALL OPF(FN.REDO.SUCESS.RATE.CHANGE,F.REDO.SUCESS.RATE.CHANGE)
*
    Y.RETURN.ARRAY = ''
    Y.CHANGED.DATE = ''
    Y.CHNG.DATE.OPER = ''
    Y.RATE.CHNG.OPER = ''
    Y.RATE.CHANGE    = ''
    Y.AA.RATE.CHANGE = ''
*
RETURN
*-----------------------------------------------------------------------------
LOCATE.VALUES:
*-------------
*
    LOCATE "CHANGE.DATE" IN D.FIELDS<1> SETTING Y.PRD.POS THEN
        Y.CHNG.DATE.OPER        = D.LOGICAL.OPERANDS<Y.PRD.POS>
        Y.CHANGED.DATE          = D.RANGE.AND.VALUE<Y.PRD.POS>
    END
*
    LOCATE "RATE.CHANGE" IN D.FIELDS<1> SETTING Y.PRD.POS THEN
        Y.RATE.CHNG.OPER   = D.LOGICAL.OPERANDS<Y.PRD.POS>
        Y.RATE.CHANGE      = D.RANGE.AND.VALUE<Y.PRD.POS>

    END
*
RETURN
*-----------------------------------------------------------------------------
SELECT.CMD:
*----------
*
    IF Y.CHANGED.DATE NE '' THEN
        SEL.CMD = "SELECT ":FN.REDO.SUCESS.RATE.CHANGE:" WITH DATE EQ ":Y.CHANGED.DATE
    END ELSE
        SEL.CMD = "SELECT ":FN.REDO.SUCESS.RATE.CHANGE
    END
*
    Y.SEL.LIST = ''
    CALL EB.READLIST(SEL.CMD,Y.SEL.LIST,'',Y.SEL.CNT,Y.SEL.ERR)
    LOOP
        REMOVE Y.REDO.RATE.CHANGE FROM Y.SEL.LIST SETTING Y.POS
    WHILE Y.REDO.RATE.CHANGE:Y.POS
*
        R.REDO.SUCESS.RATE.CHANGE = ''
        CALL F.READ(FN.REDO.SUCESS.RATE.CHANGE,Y.REDO.RATE.CHANGE,R.REDO.SUCESS.RATE.CHANGE,F.REDO.SUCESS.RATE.CHANGE,Y.RED.ERR)
        IF R.REDO.SUCESS.RATE.CHANGE NE '' THEN
            Y.OLD.RATE  = R.REDO.SUCESS.RATE.CHANGE<REDO.SUC.OLD.INTEREST.RATE>
            Y.CHNG.DATE = R.REDO.SUCESS.RATE.CHANGE<REDO.SUC.DATE>
            GOSUB CHECK.AA.INTEREST
        END
    REPEAT
RETURN
*-----------------------------------------------------------------------------
CHECK.AA.INTEREST:
*----------------
*

    Y.ARRG.ID = Y.REDO.RATE.CHANGE
    PROP.NAME='PRINCIPAL'       ;* Interest Property to obtain
    APAP.TAM.redoGetInterestProperty(ARR.ID,PROP.NAME,OUT.PROP,ERR) ;*R22 Manual Conversion
    Y.PRIN.PROP=OUT.PROP        ;* This variable hold the value of principal interest property

    PROPERTY.CLASS = 'INTEREST'
    PROPERTY = Y.PRIN.PROP
    EFF.DATE = ''
    ERR.MSG = ''
    R.INT.ARR.COND = ''
    Y.INT.RATE  = ''
    Y.POOL.RATE = ''
    APAP.AA.redoCrrGetConditions(Y.ARRG.ID,EFF.DATE,PROPERTY.CLASS,PROPERTY,R.INT.ARR.COND,ERR.MSG);*R22 Manual Conversion
    Y.INTEREST.RATE = R.INT.ARR.COND<AA.INT.EFFECTIVE.RATE>

    Y.EFFECT.DATE = Y.CHNG.DATE
*
    IF Y.INTEREST.RATE NE Y.OLD.RATE THEN
        Y.AA.RATE.CHANGE = 'YES'
    END ELSE
        Y.AA.RATE.CHANGE = 'NO'
    END
*
    IF Y.RATE.CHANGE EQ Y.AA.RATE.CHANGE THEN
        GOSUB FORM.ARRAY
    END
*
RETURN
*-----------------------------------------------------------------------------
FORM.ARRAY:
*---------
*
    IF Y.RETURN.ARRAY NE '' THEN
        Y.RETURN.ARRAY<-1> = Y.REDO.RATE.CHANGE:"*":Y.AA.RATE.CHANGE:"*":Y.EFFECT.DATE:"*":Y.OLD.RATE:"*":Y.INTEREST.RATE
    END ELSE
        Y.RETURN.ARRAY     = Y.REDO.RATE.CHANGE:"*":Y.AA.RATE.CHANGE:"*":Y.EFFECT.DATE:"*":Y.OLD.RATE:"*":Y.INTEREST.RATE
    END
*
    Y.REDO.RATE.CHANGE = ''
    Y.AA.RATE.CHANGE   = ''
    Y.EFFECT.DATE      = ''
    Y.OLD.RATE         = ''
    Y.MARGIN.RATE      = ''
*
RETURN
