* @ValidationCode : MjozNDEzOTUzODpDcDEyNTI6MTcwNTM4NjI2NTIwMDozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 Jan 2024 11:54:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.VAL.ADJBILLCHARGE.COBROS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*DATE          WHO                 REFERENCE               DESCRIPTION
*16-08-2023    VICTORIA S          R22 MANUAL CONVERSION   VM TO @VM,FM TO @FM,SM TO @SM
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ACCOUNT.DETAILS
*   $INSERT I_AA.LOCAL.COMMON ;*R22 Manual Conversion
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.AA.CHARGE
*   $INSERT I_F.AA.ARRANGEMENT.ACTIVITY ;*R22 Manual Conversion
    $INSERT I_F.AA.BALANCE.MAINTENANCE
    $USING AA.Framework

*    Y.ARR.ID = c_aalocArrId
    Y.ARR.ID = AA.Framework.getC_aalocarrid() ;*R22 Manual Conversion
*    Y.ACT.EFF.DATE = c_aalocActivityEffDate
    Y.ACT.EFF.DATE = AA.Framework.getC_aalocactivityeffdate() ;*R22 Manual Conversion
*   R.ACCOUNT.DETAILS = c_aalocAccountDetails
    R.ACCOUNT.DETAILS = AA.Framework.getC_aalocaccountdetails() ;*R22 Manual Conversion
    YAPPLN = 'AA.PRD.DES.CHARGE'
    YFIELDS = 'ChargesAmounts'
    YFIELD.POS = ''
    CALL MULTI.GET.LOC.REF(YAPPLN,YFIELDS,YFIELDS.POS)
    Y.CHARGE.AMT.POS = YFIELDS.POS<1,1>
    Idpropertyclass = ""
    Idproperty = "GESTIONCOBROS"
*    CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.ARR.ID, Idpropertyclass, Idproperty, Y.ACT.EFF.DATE, Returnids, Returnconditions, Returnerror)
    AA.Framework.GetArrangementConditions(Y.ARR.ID, Idpropertyclass, Idproperty, Y.ACT.EFF.DATE, Returnids, Returnconditions, Returnerror);* R22 UTILITY AUTO CONVERSION
    R.CHARGE = RAISE(Returnconditions)
    Y.CHARGE.AMT = R.CHARGE<AA.CHG.LOCAL.REF><1,Y.CHARGE.AMT.POS>
    Y.BILL.DATE = Y.ACT.EFF.DATE
    CALL CDT(Y.REGION,Y.BILL.DATE,'-6C')
    Y.PAYMENT.DATE.LIST = R.NEW(AA.BM.PAYMENT.DATE)
    Y.PROPERTY.LIST = R.NEW(AA.BM.PROPERTY)
    CHANGE @VM TO @FM IN Y.PAYMENT.DATE.LIST ;*R22 MANUAL CONVERSION
    CHANGE @VM TO @FM IN Y.PROPERTY.LIST ;*R22 MANUAL CONVERSION
    TOT.DATE.CNT = DCOUNT(Y.PAYMENT.DATE.LIST, @FM) ;*R22 MANUAL CONVERSION
    CNT = 1
    LOOP
    WHILE CNT LE TOT.DATE.CNT
        IF Y.BILL.DATE EQ Y.PAYMENT.DATE.LIST<CNT> THEN
            Y.TEMP.PROP.LIST = Y.PROPERTY.LIST<CNT>
            CHANGE @SM TO @FM IN Y.TEMP.PROP.LIST ;*R22 MANUAL CONVERSION
            LOCATE Idproperty IN Y.TEMP.PROP.LIST<1> SETTING PROP.POS THEN
                R.NEW(AA.BM.NEW.PROP.AMT)<1,CNT,PROP.POS> = Y.CHARGE.AMT
            END
        END
        CNT ++
    REPEAT

RETURN
END
