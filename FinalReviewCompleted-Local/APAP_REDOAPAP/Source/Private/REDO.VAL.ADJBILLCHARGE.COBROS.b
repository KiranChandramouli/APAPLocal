* @ValidationCode : MjotOTk2OTIyNDU6Q3AxMjUyOjE2ODUwMTUyMzMxNTY6dmljdG86LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 May 2023 17:17:13
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.VAL.ADJBILLCHARGE.COBROS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*DATE           WHO                 REFERENCE               DESCRIPTION
*25-05-2023    CONVERSION TOOL     R22 AUTO CONVERSION     VM TO @VM,FM TO @FM,SM TO @SM,++ TO +=1
*25-05-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_AA.LOCAL.COMMON
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.AA.CHARGE
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.BALANCE.MAINTENANCE

    Y.ARR.ID = c_aalocArrId
    Y.ACT.EFF.DATE = c_aalocActivityEffDate
    R.ACCOUNT.DETAILS = c_aalocAccountDetails
    YAPPLN = 'AA.PRD.DES.CHARGE'
    YFIELDS = 'ChargesAmounts'
    YFIELD.POS = ''
    CALL MULTI.GET.LOC.REF(YAPPLN,YFIELDS,YFIELDS.POS)
    Y.CHARGE.AMT.POS = YFIELDS.POS<1,1>
    Idpropertyclass = ""
    Idproperty = "GESTIONCOBROS"
    CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.ARR.ID, Idpropertyclass, Idproperty, Y.ACT.EFF.DATE, Returnids, Returnconditions, Returnerror)
    R.CHARGE = RAISE(Returnconditions)
    Y.CHARGE.AMT = R.CHARGE<AA.CHG.LOCAL.REF><1,Y.CHARGE.AMT.POS>

    ARR.PAYMENT.DATE.LIST = R.ACCOUNT.DETAILS<AA.AD.PAYMENT.DATE>
    ARR.PROPERTY.LIST = R.ACCOUNT.DETAILS<AA.AD.PROPERTY>

    CHANGE @VM TO @FM IN ARR.PAYMENT.DATE.LIST ;*R22 AUTO CONVERSION
    CHANGE @VM TO @FM IN ARR.PROPERTY.LIST ;*R22 AUTO CONVERSION

    LOCATE Idproperty IN ARR.PROPERTY.LIST<1> SETTING PROP.AR.POS THEN
        Y.BILL.DATE = ARR.PAYMENT.DATE.LIST<PROP.AR.POS>
    END

    Y.PAYMENT.DATE.LIST = R.NEW(AA.BM.PAYMENT.DATE)
    Y.PROPERTY.LIST = R.NEW(AA.BM.PROPERTY)
    CHANGE @VM TO @FM IN Y.PAYMENT.DATE.LIST ;*R22 AUTO CONVERSION
    CHANGE @VM TO @FM IN Y.PROPERTY.LIST ;*R22 AUTO CONVERSION

    TOT.DATE.CNT = DCOUNT(Y.PAYMENT.DATE.LIST, @FM) ;*R22 AUTO CONVERSION
    CNT = 1
    LOOP
    WHILE CNT LE TOT.DATE.CNT
        IF Y.BILL.DATE EQ Y.PAYMENT.DATE.LIST<CNT> THEN
            Y.TEMP.PROP.LIST = Y.PROPERTY.LIST<CNT>
            CHANGE @SM TO @FM IN Y.TEMP.PROP.LIST ;*R22 AUTO CONVERSION
            LOCATE Idproperty IN Y.TEMP.PROP.LIST<1> SETTING PROP.POS THEN
                R.NEW(AA.BM.NEW.PROP.AMT)<1,CNT,PROP.POS> = Y.CHARGE.AMT
            END
        END
        CNT += 1 ;*R22 AUTO CONVERSION
    REPEAT

RETURN
END
