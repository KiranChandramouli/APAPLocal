* @ValidationCode : MjoxNTA1MjUyNTU6Q3AxMjUyOjE2ODI0MTIzNjQzNTk6SGFyaXNodmlrcmFtQzotMTotMTowOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:16:04
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
SUBROUTINE REDO.V.VAL.SECURITY.TAG
*----------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*17-04-2023       Conversion Tool        R22 Auto Code conversion          FM TO @FM
*17-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER.DEFAULT


INITIALISE:
*---------
*

    FN.TELLER.DEFAULT = 'F.TELLER.DEFAULT'
    F.TELLER.DEFAULT  = ''
    CALL OPF(FN.TELLER.DEFAULT, F.TELLER.DEFAULT)

    R.TELLER.DEFAULT = ''
    TT.DEF.ID        = ''


PROCESS:
*-------
*

    TT.DEF.ID = COMI
    CALL F.READ(FN.TELLER.DEFAULT, TT.DEF.ID, R.TELLER.DEFAULT, F.TELLER.DEFAULT, TD.ERR)

*** Check Record already exists
**
    IF NOT(TD.ERR) OR R.TELLER.DEFAULT THEN
        PREV.REF = R.TELLER.DEFAULT<TT.DEF.ADDITIONAL.DATA.1>
        ETEXT    = "TT-REDO.SEC.TAG.PROCESSED" : @FM : PREV.REF
    END

RETURN
END
