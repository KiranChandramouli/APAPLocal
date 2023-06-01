* @ValidationCode : Mjo5MTI0MTI5MTI6Q3AxMjUyOjE2ODI0MTIzNDA3OTQ6SGFyaXNodmlrcmFtQzotMTotMTowOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:40
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
SUBROUTINE REDO.V.AUTH.UPDATE.LOGFILE
*-------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*10-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*10-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT

    FN.REDO.T.AZ.MODIFY.LOG = 'F.REDO.T.AZ.MODIFY.LOG'
    F.REDO.T.AZ.MODIFY.LOG = ''
    CALL OPF(FN.REDO.T.AZ.MODIFY.LOG, F.REDO.T.AZ.MODIFY.LOG)

    Y.ID = TODAY
    Y.VALUE = ID.NEW

    CALL CONCAT.FILE.UPDATE(FN.REDO.T.AZ.MODIFY.LOG, Y.ID, Y.VALUE, 'I', 'AR')

RETURN
END
