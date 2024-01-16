* @ValidationCode : MjoyMTMxNDQ4MjE1OkNwMTI1MjoxNzA1MDM3NzU4MDYzOnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Jan 2024 11:05:58
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*25/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION      FM TO @FM, VM TO @VM, SM TO @SM,++ TO +=, F.READ TO CACHE.READ
*25/04/2023         SURESH           MANUAL R22 CODE CONVERSION         CALL routine format modified
*11-01-2024        VIGNESHWARI      R22 MANUAL CODE CONVERSION          AA.FRAMEWORK IS CHANGED, f.read IS modified
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.GET.INDV.REPAY.AMT(TRANS.REF,ARR.ID,TOTAL.AMT,Y.PAY.DATE)
*

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.REFERENCE.DETAILS
*    $INSERT I_F.AA.ACTIVITY.BALANCES
 *   $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.PROPERTY
  *  $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.REDO.APAP.PROPERTY.PARAM
   $USING AA.Framework

    IF TRANS.REF EQ '' OR ARR.ID EQ '' THEN
        TOTAL.AMT = 0
        GOSUB PGM.END
    END


    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*-----------------------------------------
OPENFILES:
*-----------------------------------------

    FN.AA.REFERENCE.DETAILS = 'F.AA.REFERENCE.DETAILS'
    F.AA.REFERENCE.DETAILS  = ''
    CALL OPF(FN.AA.REFERENCE.DETAILS,F.AA.REFERENCE.DETAILS)

    FN.AA.ACTIVITY.BALANCES = 'F.AA.ACTIVITY.BALANCES'
    F.AA.ACTIVITY.BALANCES  = ''
    CALL OPF(FN.AA.ACTIVITY.BALANCES,F.AA.ACTIVITY.BALANCES)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT  = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.REDO.APAP.PROPERTY.PARAM = 'F.REDO.APAP.PROPERTY.PARAM'

    FN.AA.PROPERTY = 'F.AA.PROPERTY'
    F.AA.PROPERTY  = ''
    CALL OPF(FN.AA.PROPERTY,F.AA.PROPERTY)

    FN.AA.ARRANGEMENT.ACTIVITY$NAU = 'F.AA.ARRANGEMENT.ACTIVITY$NAU'
    F.AA.ARRANGEMENT.ACTIVITY$NAU  = ''
    CALL OPF(FN.AA.ARRANGEMENT.ACTIVITY$NAU,F.AA.ARRANGEMENT.ACTIVITY$NAU)

    FN.AA.ARRANGEMENT.ACTIVITY = 'F.AA.ARRANGEMENT.ACTIVITY'
    F.AA.ARRANGEMENT.ACTIVITY  = ''
    CALL OPF(FN.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY)

    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS  = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    Y.PRINCIPAL.AMT = 0
    Y.INTEREST.AMT  = 0
    Y.CHARGE.AMT    = 0
    Y.PENALTY.AMT   = 0
    Y.ADVANCE.AMT   = 0

RETURN
*-----------------------------------------
PROCESS:
*-----------------------------------------

   * CALL F.READ(FN.AA.ARRANGEMENT,ARR.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,ARR.ERR)
R.AA.ARRANGEMENT = AA.Framework.Arrangement.Read(ARR.ID, ARR.ERR)
   * Y.PRODUCT.GROUP = R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
      Y.PRODUCT.GROUP = R.AA.ARRANGEMENT<AA.Framework.ArrangementSim.ArrProductGroup> ;*R22 MANUAL CODE CONVERSION-AA.FRAMEWORK IS CHANGED

    GOSUB GET.PRINCIPAL.PROP
    GOSUB GET.INTEREST.PROP
    GOSUB GET.PENALTY.PROP
    GOSUB GET.TRANSACTION.DETAILS
*********************************************
    TOTAL.AMT  =  Y.PRINCIPAL.AMT:'*':Y.INTEREST.AMT:'*':Y.CHARGE.AMT:'*':Y.PENALTY.AMT:'*':Y.ADVANCE.AMT:'*':Y.PRIN.DEC.AMT:'*':Y.GEST.AMT
*********************************************
    IF Y.OLD.BILL AND Y.NEW.BILL THEN
        Y.LD.BIL = ICONV(Y.OLD.BILL,'D')
        Y.EW.BIL = ICONV(Y.NEW.BILL,'D')
        Y.PAY.DATE =  OCONV(Y.LD.BIL, "D0"):'-':OCONV(Y.EW.BIL, "D0")
    END ELSE
        Y.PAY.DATE = ''
    END
RETURN
*-----------------------------------------
GET.PRINCIPAL.PROP:
*-----------------------------------------
    IN.PROPERTY.CLASS = 'ACCOUNT'
    OUT.PROPERTY      = ''
*APAP.TAM.REDO.GET.PROPERTY.NAME(ARR.ID,IN.PROPERTY.CLASS,R.OUT.AA.RECORD,OUT.PROPERTY,OUT.ERR) ;*MANUAL R22 CODE CONVERSION
    APAP.TAM.redoGetPropertyName(ARR.ID,IN.PROPERTY.CLASS,R.OUT.AA.RECORD,OUT.PROPERTY,OUT.ERR) ;*MANUAL R22 CODE CONVERSION
    Y.PRINCIPAL.PROP = OUT.PROPERTY

RETURN
*-----------------------------------------
GET.INTEREST.PROP:
*-----------------------------------------
    ARR.INFO    = ''
    ARR.INFO<1> = ARR.ID
    R.ARRANGEMENT = ''
    Y.EFF.DATE = TODAY
*    CALL AA.GET.ARRANGEMENT.PROPERTIES(ARR.INFO, Y.EFF.DATE, R.ARRANGEMENT, PROP.LIST)
AA.Framework.GetArrangementProperties(ARR.INFO, Y.EFF.DATE, R.ARRANGEMENT, PROP.LIST);* R22 UTILITY AUTO CONVERSION

    CLASS.LIST = ''
    CALL AA.GET.PROPERTY.CLASS(PROP.LIST, CLASS.LIST)       ;* Find their Property classes

    CLASS.LIST = RAISE(CLASS.LIST)
    PROP.LIST = RAISE(PROP.LIST)
    CLASS.CTR = ''
    Y.INTEREST.PROPERTY = ''

    LOOP
        REMOVE Y.CLASS FROM CLASS.LIST SETTING CLASS.POS
        CLASS.CTR +=1
    WHILE Y.CLASS:CLASS.POS
        IF Y.CLASS EQ "INTEREST" THEN
            Y.INTEREST.PROPERTY<1,-1> = PROP.LIST<CLASS.CTR>          ;*Get the interest property
        END
    REPEAT

RETURN
*-----------------------------------------
GET.PENALTY.PROP:
*-----------------------------------------

    CALL CACHE.READ(FN.REDO.APAP.PROPERTY.PARAM,Y.PRODUCT.GROUP,R.REDO.APAP.PROPERTY.PARAM,PAR.ERR)
    Y.PENALTY.CHARGE.PROP = R.REDO.APAP.PROPERTY.PARAM<PROP.PARAM.PENALTY.ARREAR>

RETURN
*-----------------------------------------
GET.TRANSACTION.DETAILS:
*-----------------------------------------

    CALL F.READ(FN.AA.ACCOUNT.DETAILS,ARR.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,ACD.ERR)

    Y.ALL.BILL.IDS   = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID>
    Y.ALL.BILL.DATES = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.DATE>

    CHANGE @SM TO @FM IN Y.ALL.BILL.IDS
    CHANGE @VM TO @FM IN Y.ALL.BILL.IDS
    CHANGE @SM TO @FM IN Y.ALL.BILL.DATES
    CHANGE @VM TO @FM IN Y.ALL.BILL.DATES


    Y.OLD.BILL = ''
    Y.NEW.BILL = ''
    CALL F.READ(FN.AA.REFERENCE.DETAILS,ARR.ID,R.AA.REFERENCE.DETAILS,F.AA.REFERENCE.DETAILS,AA.REF.ERR)
    LOCATE TRANS.REF IN R.AA.REFERENCE.DETAILS<AA.REF.TRANS.REF,1> SETTING POS1 THEN
        Y.AAA.ID = R.AA.REFERENCE.DETAILS<AA.REF.AAA.ID,POS1>
        GOSUB GET.LIST.OF.AAA ;* Including child activity
        *CALL F.READ(FN.AA.ACTIVITY.BALANCES,ARR.ID,R.AA.ACTIVITY.BALANCES,F.AA.ACTIVITY.BALANCES,AA.ACT.ERR)
      R.AA.ACTIVITY.BALANCES = AA.Framework.ActivityBalances.Read(ARR.ID, AA.ACT.ERR) ;*R22 MANUAL CODE CONVERSION-AA.FRAMEWORK IS CHANGED
        Y.FINAL.AAA.ID = CHANGE(Y.FINAL.AAA.ID,@VM,@FM)
        Y.ACT.CNT = DCOUNT(Y.FINAL.AAA.ID,@FM)
        Y.LOOP1 = 1
        LOOP
        WHILE Y.LOOP1 LE Y.ACT.CNT
            Y.AAA.ID.INDV = Y.FINAL.AAA.ID<Y.LOOP1>
       *     LOCATE Y.AAA.ID.INDV IN R.AA.ACTIVITY.BALANCES<AA.ACT.BAL.ACTIVITY.REF,1> SETTING POS2 THEN
        *        Y.PROPERTY     = R.AA.ACTIVITY.BALANCES<AA.ACT.BAL.PROPERTY,POS2>
                LOCATE Y.AAA.ID.INDV IN R.AA.ACTIVITY.BALANCES< AA.Framework.ActivityBalances.ActBalActivityRef,1> SETTING POS2 THEN    ;*R22 MANUAL CODE CONVERSION-AA.FRAMEWORK IS CHANGED
                Y.PROPERTY     = R.AA.ACTIVITY.BALANCES<AA.Framework.ActivityBalances.ActBalProperty,POS2>  ;*R22 MANUAL CODE CONVERSION-AA.FRAMEWORK IS CHANGED
                Y.PROPERTY.BAL.TYPE = FIELDS(Y.PROPERTY,'.',1)
                Y.PRO.AC.BAL.TYPES = FIELDS(Y.PROPERTY,'.',2)
               * Y.PROPERTY.AMT = R.AA.ACTIVITY.BALANCES<AA.ACT.BAL.PROPERTY.AMT,POS2>
                Y.PROPERTY.AMT = R.AA.ACTIVITY.BALANCES<AA.Framework.ActivityBalances.ActBalPropertyAmt,POS2>   ;*R22 MANUAL CODE CONVERSION-AA.FRAMEWORK IS CHANGED

                GOSUB CALC.AMT
                GOSUB GET.BILL.DATES
            END
            Y.LOOP1 += 1 ;*AUTO R22 CODE CONVERSION
        REPEAT
    END

RETURN
*-----------------------------------------
CALC.AMT:
*-----------------------------------------
    Y.PROP.CNT = DCOUNT(Y.PROPERTY,@SM)
    Y.CNT1 = 1
    LOOP
    WHILE Y.CNT1 LE Y.PROP.CNT
        Y.PROP = Y.PROPERTY.BAL.TYPE<1,1,Y.CNT1>
        Y.PR.BAL.TYP = Y.PRO.AC.BAL.TYPES<1,1,Y.CNT1>
        CALL CACHE.READ(FN.AA.PROPERTY, Y.PROP, R.PROP.REC, PP.ERR) ;*AUTO R22 CODE CONVERSION
        Y.PROP.CLASS = R.PROP.REC<AA.PROP.PROPERTY.CLASS>

        BEGIN CASE
            CASE Y.PROP EQ Y.PRINCIPAL.PROP AND Y.PR.BAL.TYP NE 'CURACCOUNT' AND Y.PR.BAL.TYP NE 'UNCACCOUNT'
                Y.PRINCIPAL.AMT += Y.PROPERTY.AMT<1,1,Y.CNT1>
            CASE Y.PROP EQ Y.PRINCIPAL.PROP AND Y.PR.BAL.TYP EQ 'CURACCOUNT'
                Y.PRIN.DEC.AMT += Y.PROPERTY.AMT<1,1,Y.CNT1>
            CASE Y.PROP MATCHES Y.INTEREST.PROPERTY
                Y.INTEREST.AMT  += Y.PROPERTY.AMT<1,1,Y.CNT1>
            CASE Y.PROP EQ Y.PENALTY.CHARGE.PROP
                Y.PENALTY.AMT   += Y.PROPERTY.AMT<1,1,Y.CNT1>
****************************************************
            CASE Y.PROP NE Y.PENALTY.CHARGE.PROP AND Y.PROP EQ 'GESTIONCOBROS'
                Y.GEST.AMT    += Y.PROPERTY.AMT<1,1,Y.CNT1>
****************************************************
            CASE Y.PROP NE Y.PENALTY.CHARGE.PROP AND Y.PROP.CLASS EQ 'CHARGE'
                Y.CHARGE.AMT    += Y.PROPERTY.AMT<1,1,Y.CNT1>
        END CASE
        Y.CNT1 += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT


RETURN
*-----------------------------------------
GET.LIST.OF.AAA:
*-----------------------------------------

    Y.FINAL.AAA.ID = ''
    Y.LOOP.BRK = 1
    LOOP
    WHILE Y.LOOP.BRK
        Y.FINAL.AAA.ID<-1> = Y.AAA.ID
        Y.AA.CNT = DCOUNT(Y.AAA.ID,@VM)
        IF Y.AA.CNT EQ 1 THEN
            R.AAA = ''
          *  CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY$NAU,Y.AAA.ID,R.AAA,F.AA.ARRANGEMENT.ACTIVITY$NAU,AAA.ERR)
           R.AAA = AA.Framework.ArrangementActivity.ReadNau(Y.AAA.ID, AAA.ERR);*R22 MANUAL CODE CONVERSION-f.read IS modified
            
            IF R.AAA ELSE
             *   CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY,Y.AAA.ID,R.AAA,F.AA.ARRANGEMENT.ACTIVITY,AAA.ERR)                
                R.AAA = AA.Framework.ArrangementActivity.Read(Y.AAA.ID, AAA.ERR);*R22 MANUAL CODE CONVERSION-f.read IS modified
            END
*            Y.CHILD.ACTIVITY = R.AAA<AA.ARR.ACT.CHILD.ACTIVITY>
*            IF R.AAA<AA.ARR.ACT.ACTIVITY.CLASS> EQ 'LENDING-CREDIT-ARRANGEMENT' THEN
*                Y.ADVANCE.AMT += R.AAA<AA.ARR.ACT.ORIG.TXN.AMT>
             ;*R22 MANUAL CODE CONVERSION-AA.FRAMEWORK IS CHANGED-START   
             Y.CHILD.ACTIVITY = R.AAA<AA.Framework.SimulationCapture.ArrActChildActivity>
            IF R.AAA<AA.Framework.SimulationCapture.ArrActActivityClass> EQ 'LENDING-CREDIT-ARRANGEMENT' THEN
                Y.ADVANCE.AMT += R.AAA<AA.Framework.RrControl.ArrActOrigTxnAmt>   
           ;*R22 MANUAL CODE CONVERSION-AA.FRAMEWORK IS CHANGED-END
            END

            Y.AAA.ID = Y.CHILD.ACTIVITY
            IF Y.CHILD.ACTIVITY ELSE
                Y.LOOP.BRK = 0
            END
        END ELSE
            FLG = '' ; Y.CHLD.CHLDS = ''
            LOOP
            WHILE Y.AA.CNT GT 0 DO
                FLG += 1
                R.AAA = ''
                Y.AAA.IDD = Y.AAA.ID<1,FLG>
               * CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY$NAU,Y.AAA.IDD,R.AAA,F.AA.ARRANGEMENT.ACTIVITY$NAU,AAA.ERR)
                R.AAA = AA.Framework.ArrangementActivity.ReadNau(Y.AAA.IDD, AAA.ERR);*r22 manual code conversion-f.read is modified
                IF R.AAA ELSE
                    *CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY,Y.AAA.IDD,R.AAA,F.AA.ARRANGEMENT.ACTIVITY,AAA.ERR)
                    R.AAA = AA.Framework.ArrangementActivity.Read(Y.AAA.IDD, AAA.ERR);*r22 manual code conversion-f.read is modified
                END
*                Y.CHILD.ACTI = R.AAA<AA.ARR.ACT.CHILD.ACTIVITY>
*                IF R.AAA<AA.ARR.ACT.ACTIVITY.CLASS> EQ 'LENDING-CREDIT-ARRANGEMENT' THEN
*                    Y.ADVANCE.AMT += R.AAA<AA.ARR.ACT.ORIG.TXN.AMT>
                 ;*R22 MANUAL CODE CONVERSION-AA.FRAMEWORK IS CHANGED-START   
                Y.CHILD.ACTI = R.AAA<AA.Framework.SimulationCapture.ArrActChildActivity>
                IF R.AAA<AA.Framework.SimulationCapture.ArrActActivityClass> EQ 'LENDING-CREDIT-ARRANGEMENT' THEN
                    Y.ADVANCE.AMT += R.AAA<AA.Framework.RrControl.ArrActOrigTxnAmt> 
                    ;*R22 MANUAL CODE CONVERSION-AA.FRAMEWORK IS CHANGED-END   
                END

                IF Y.CHILD.ACTI THEN
                    Y.CHLD.CHLDS<1,-1> = Y.CHILD.ACTI
                END

                Y.AA.CNT -= 1
            REPEAT
            IF Y.CHLD.CHLDS THEN
                Y.AAA.ID = Y.CHLD.CHLDS
            END ELSE
                Y.LOOP.BRK = 0
            END
        END

    REPEAT
RETURN
*-----------------------------------------
GET.BILL.DATES:
*-----------------------------------------

    FINDSTR Y.AAA.ID.INDV IN R.AA.ACCOUNT.DETAILS<AA.AD.REPAY.REFERENCE> SETTING Y.AF,Y.AV,Y.AS THEN
        Y.BILL.IDS = R.AA.ACCOUNT.DETAILS<AA.AD.RPY.BILL.ID,Y.AV>
    END ELSE
        RETURN
    END

    Y.BILLS.CNT = DCOUNT(Y.BILL.IDS,@SM)
    Y.VAR4 = 1

    LOOP
    WHILE Y.VAR4 LE Y.BILLS.CNT
        Y.BILL.ID = Y.BILL.IDS<1,1,Y.VAR4>
        R.BILL.DETAILS = ''
        RET.ERROR = ''
        CALL AA.GET.BILL.DETAILS(ARR.ID, Y.BILL.ID, R.BILL.DETAILS, RET.ERROR)
        FINDSTR Y.AAA.ID.INDV IN R.BILL.DETAILS<AA.BD.REPAY.REF> SETTING Y.AF1,Y.AF2,Y.AF3 ELSE
            Y.VAR4 += 1 ;*AUTO R22 CODE CONVERSION
            CONTINUE
        END
        LOCATE Y.BILL.ID IN Y.ALL.BILL.IDS SETTING BILL.POS THEN
            Y.BILL.DATE = Y.ALL.BILL.DATES<BILL.POS>
        END ELSE
            Y.VAR4 += 1 ;*AUTO R22 CODE CONVERSION
            CONTINUE

        END
        IF Y.OLD.BILL THEN
            IF Y.BILL.DATE LT Y.OLD.BILL THEN
                Y.OLD.BILL = Y.BILL.DATE
            END
        END ELSE
            Y.OLD.BILL = Y.BILL.DATE
        END
        IF Y.NEW.BILL THEN
            IF Y.BILL.DATE GT Y.NEW.BILL THEN
                Y.NEW.BILL = Y.BILL.DATE
            END
        END ELSE
            Y.NEW.BILL = Y.BILL.DATE
        END
        Y.VAR4 += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT

RETURN

*-----------------------------------------
PGM.END:
END
