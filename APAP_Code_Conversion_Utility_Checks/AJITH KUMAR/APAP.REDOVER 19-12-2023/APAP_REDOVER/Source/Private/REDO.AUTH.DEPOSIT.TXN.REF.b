* @ValidationCode : MjotMjA2NDg1OTg5MDpDcDEyNTI6MTY4MjQxMjMyNzg4NDpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
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
*-----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.AZ.ACCOUNT

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
    CALL GET.LOC.REF('AZ.ACCOUNT','L.AZ.REF.NO',LOC.POS)

RETURN
*-------
PROCESS:
*-------
    Y.VALUE= R.NEW(TT.TE.ACCOUNT.2)
    Y.TXN.REF = ID.NEW
    CALL F.READ(FN.AZ.ACCOUNT,Y.VALUE,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ACC.ERR)
    R.AZ.ACCOUNT<AZ.LOCAL.REF,LOC.POS> = Y.TXN.REF
    CALL F.WRITE(FN.AZ.ACCOUNT,Y.VALUE,R.AZ.ACCOUNT)
RETURN

END
