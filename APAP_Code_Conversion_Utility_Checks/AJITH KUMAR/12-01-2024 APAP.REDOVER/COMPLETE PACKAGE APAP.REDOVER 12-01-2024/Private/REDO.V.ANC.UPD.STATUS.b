* @ValidationCode : MjotMTAxNzA0OTU3NjpDcDEyNTI6MTY4MjQxMjMzMjk4ODpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:32
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
SUBROUTINE REDO.V.ANC.UPD.STATUS
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Pradeep S
* Program Name  : REDO.V.ANC.UPD.STATUS
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Description   : This ANC routine attached in notify version for Request to update the STATUS field
* In parameter  : None
* out parameter : None
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Date             Author             Reference                     Description
* 21-May-2011      Pradeep S          PACS00060849                   Initial Creation
*06-04-2023       Conversion Tool     R22 Auto Code conversion         No Changes
*06-04-2023       Samaran T          R22 Manual Code Conversion       No Changes
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ISSUE.REQUESTS

    GOSUB PROCESS

RETURN
*-------
PROCESS:
*-------
    Y.CURR.STATUS = R.NEW(ISS.REQ.STATUS)
    Y.CURR.CLOSE.STATUS = R.NEW(ISS.REQ.CLOSING.STATUS)

    BEGIN CASE

        CASE Y.CURR.CLOSE.STATUS EQ 'ACCEPTED'
            R.NEW(ISS.REQ.STATUS) = 'RESOLUCION NOTIFICADA'

        CASE Y.CURR.CLOSE.STATUS EQ 'REJECTED'
            R.NEW(ISS.REQ.STATUS) = 'RECHAZADA NOTIFICADA'

    END CASE

RETURN
END
