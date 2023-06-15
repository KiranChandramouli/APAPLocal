* @ValidationCode : MjoxNzM5OTIzMzY6Q3AxMjUyOjE2ODIwNzMzNzk5MDU6SVRTUzotMTotMTotMTU6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Apr 2023 16:06:19
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -15
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CONV.WITH.PERCENTAGE
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CONV.WITH.PERCENTAGE
*------------------------------------------------------------------------------
*Description  : This is a conversion routine used to fetch the value of TERM from AA.ARR.COMMITMENT
*Linked With  :
*In Parameter : O.DATA
*Out Parameter: O.DATA
*-------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                        Reference                    Description
*   ------          ------                      -------------                -------------
* 24-06-2011       RIYAS                           PACS00061656 B23B       Initial Creation
* 17-APR-2023     Conversion tool    		R22 Auto conversion       No changes
* 17-APR-2023      Harishvikram C           Manual R22 conversion      No changes
*--------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.H.PROVISION.PARAMETER

    GOSUB INITIALISE
    GOSUB PROCESS
RETURN
*---------------------------
INITIALISE:
*---------------------------
    Y.INT.PER=O.DATA
    Y.TERM.VALUE = ''
RETURN
*------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------
    Y.FIN.PER=Y.INT.PER[1,2]
    O.DATA=Y.FIN.PER:'%'

RETURN
*-------------------------------------------------------------------------------------
END
