* @ValidationCode : Mjo4MzEwMTA5NzA6Q3AxMjUyOjE3MDMyMjkyNTAzNjA6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 22 Dec 2023 12:44:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.AUTH.OVE.MESSAGE
*-------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : SUDHARSANAN S
* Program Name : REDO.AUTH.OVE.MESSAGE
* ODR Number : ODR-2009-10-0317
*-------------------------------------------------------------------------

* Description :This validation routine is used to warn when the user does any
* change to the ACI table manually by triggering a Warning Message

* Linked with: ACI,MAN.UPD
* In parameter : None
* out parameter : None
***---------------------------------------------------------------
***--------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE WHO REFERENCE DESCRIPTION
*08.09.2010 S SUDHARSANAN HD1036878 INITIAL CREATION
*---------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*05-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*05-04-2023           Samaran T           Manual R22 Code Conversion       No Changes
* 21-12-2023      AJITHKUMAR      R22 MANUAL CODE CONVERSION
*-----------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCOUNT.CREDIT.INT
    $USING EB.LocalReferences

    GOSUB INIT
    GOSUB PROCESS
RETURN
*--------------
INIT:
*---------------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    LOC.REF.POS = ''

*CALL GET.LOC.REF('ACCOUNT','L.AC.MAN.UPD',LOC.REF.POS)
    EB.LocalReferences.GetLocRef('ACCOUNT','L.AC.MAN.UPD',LOC.REF.POS);*R22 MANUAL CODE CONVERSION
RETURN
*--------------
PROCESS:
*--------------
    Y.ACI.ID = ID.NEW
    Y.ACC.ID = FIELD(Y.ACI.ID,'-',1)

    CALL F.READ(FN.ACCOUNT,Y.ACC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    Y.MAN.UPD = R.ACCOUNT<AC.LOCAL.REF,LOC.REF.POS>
    IF Y.MAN.UPD EQ 'NO' THEN
* TEXT = ''
* TEXT = 'To Keep Changes Set L.AC.MAN.UPD on the Account record to YES'
* CALL REM
* E = 'EB-ACI.MAN.UPD'
        TEXT='EB-ACI.MAN.UPD'
        CALL STORE.OVERRIDE(CURR.NO)
    END
RETURN

END
