* @ValidationCode : MjotMTUyMTg0MjUxOkNwMTI1MjoxNjgwNjU4NDQ3NTk1OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 07:04:07
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.CHK.AZ.BAL.CONSOL
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* DESCRIPTION : This routine will be executed at check Record Routine for the deposit versions.
* It is used to update the L.AZ.BAL.CONSOL field based on the previous deposit.
*------------------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN : -NA-
* OUT : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.CHK.AZ.BAL.CONSOL
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE WHO REFERENCE DESCRIPTION
* 08-11-2011 Sudharsanan S CR.18 Initial Creation.

* Date             Who                   Reference      Description
* 05.04.2023       Conversion Tool       R22            Auto Conversion     - FM TO @FM
* 05.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
* -----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.CUSTOMER

    GOSUB INIT
    VAR.CURR.NO = R.OLD(AZ.CURR.NO)
    IF NOT(VAR.CURR.NO) THEN
        GOSUB PROCESS
    END
RETURN
*-----------------------------------------------------------------------------
INIT:
*-------------------------------------------------------------------------------
    FN.AZ.ACCOUNT='F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.AZ.CUSTOMER = 'F.AZ.CUSTOMER'
    F.AZ.CUSTOMER = ''
    CALL OPF(FN.AZ.CUSTOMER,F.AZ.CUSTOMER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    LOC.REF.APP = 'AZ.ACCOUNT'
    LOC.REF.FIELD = 'L.AZ.BAL.CONSOL'
    LOC.REF.POS = ''
    CALL GET.LOC.REF(LOC.REF.APP,LOC.REF.FIELD,LOC.REF.POS)

RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------------
    VAR.ACC.ID = ID.NEW
    CALL F.READ(FN.ACCOUNT,VAR.ACC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)

    VAR.CUSTOMER = R.ACCOUNT<AC.CUSTOMER>
    CALL F.READ(FN.AZ.CUSTOMER,VAR.CUSTOMER,R.AZ.CUSTOMER,F.AZ.CUSTOMER,AZ.CUS.ERR)

    IF NOT(R.AZ.CUSTOMER) THEN
        VAR.BAL.CONSOL = 'N'
    END ELSE
        CNT.AZ.ID = DCOUNT(R.AZ.CUSTOMER,@FM)
        Y.AZ.ID = R.AZ.CUSTOMER<CNT.AZ.ID>
        CALL F.READ(FN.AZ.ACCOUNT,Y.AZ.ID,R.AZ.ACC,F.AZ.ACCOUNT,AZ.ERR)
        VAR.BAL.CONSOL = R.AZ.ACC<AZ.LOCAL.REF,LOC.REF.POS>
    END
    R.NEW(AZ.LOCAL.REF)<1,LOC.REF.POS> = VAR.BAL.CONSOL
RETURN
*---------------------------------------------------------------------------------------------------------------
END
