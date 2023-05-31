* @ValidationCode : Mjo4Mzk2ODkwODM6Q3AxMjUyOjE2ODExMDk4NDMyOTM6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Apr 2023 12:27:23
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
SUBROUTINE REDO.TT.GROUP.PARAM.VALIDATE
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.TT.GROUP.PARAM.VALIDATE
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.TT.GROUP.PARAM.VALIDATE is a validation routine attached to the TEMPLATE
*                    - REDO.TT.GROUP.PARAM, the routine checks if the duplicate value entered in the
*                    GROUP field
*Linked With       : Template - REDO.TT.GROUP.PARAM
*In  Parameter     : NA
*Out Parameter     : NA
*Files  Used       : REDO.TT.GROUP.PARAM           As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                  Reference                  Description
*   ------            ------               -------------               -------------
* 23 Sep 2010       Sudharsanan S         PACS00062653                  Initial Creation
* 10.04.2023       Conversion Tool        R22                         Auto Conversion     - No changes
* 10.04.2023       Shanmugapriya M        R22                         Manual Conversion   - No changes
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.TT.GROUP.PARAM
*-------------------------------------------------------------------------------------------------------
    GOSUB CHECK.DUP
RETURN
*--------------------------------------------------------------------------------------------------------
**********
CHECK.DUP:
**********
    AF = TEL.GRO.GROUP
    CALL DUP

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
