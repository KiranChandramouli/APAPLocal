* @ValidationCode : MjotMTUyNTE4MDExNTpDcDEyNTI6MTcwMzE2MTY3MTM4MDphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Dec 2023 17:57:51
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
SUBROUTINE REDO.AUTH.DEPOSIT.TXN.REF
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine will update TT id to the Deposit account
*--------------
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Revision History:
*------------------------------------------------------------------------------------------
* Date who Reference Description
* 17.04.2012 S.Sudharsanan PACS00190868 Initial Creation
*------------------------------------------------------------------------------------------

*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*05-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*05-04-2023       Samaran T              Manual R22 Code Conversion        No Changes
* 21-12-2023      AJITHKUMAR      R22 MANUAL CODE CONVERSION
*-----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.AZ.ACCOUNT
    $USING EB.LocalReferences
     

    GOSUB INIT
    GOSUB PROCESS
RETURN
*-----
INIT:
*-----

    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)
    LOC.POS = ''
* CALL GET.LOC.REF('AZ.ACCOUNT','L.AZ.REF.NO',LOC.POS)
    EB.LocalReferences.GetLocRef('AZ.ACCOUNT','L.AZ.REF.NO',LOC.POS)

RETURN
*-------
PROCESS:
*-------
    Y.VALUE= R.NEW(TT.TE.ACCOUNT.2)
    Y.TXN.REF = ID.NEW
* CALL F.READ(FN.AZ.ACCOUNT,Y.VALUE,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ACC.ERR)
    CALL F.READ(FN.AZ.ACCOUNT,Y.VALUE,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ACC.ERR,'');*R22 MANUAL CODE CONVERSION
    R.AZ.ACCOUNT<AZ.LOCAL.REF,LOC.POS> = Y.TXN.REF
    CALL F.WRITE(FN.AZ.ACCOUNT,Y.VALUE,R.AZ.ACCOUNT)
RETURN

END
