* @ValidationCode : Mjo0NTA4MzkxNjk6Q3AxMjUyOjE2ODA2NTg0NDc4NDc6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
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
SUBROUTINE REDO.CHQ.PRNT.VERSIONS.VALIDATE
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CHQ.PRNT.VERSIONS.VALIDATE
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.CHQ.PRNT.VERSIONS.VALIDATE is a validation routine attached to the TEMPLATE
*                    - REDO.CHQ.PRNT.VERSIONS, the routine checks if the duplicate value entered in the
*                    VERSIONS field
*Linked With       : Template - REDO.CHQ.PRNT.VERSIONS
*In  Parameter     : NA
*Out Parameter     : NA
*Files  Used       : REDO.CHQ.PRNT.VERSIONS           As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                  Reference                  Description
*   ------            ------               -------------               -------------
* 23 Sep 2010         Nava V.              PACS00239746                Initial Creation

* Date             Who                   Reference      Description
* 05.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 05.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CHQ.PRNT.VERSIONS
*-------------------------------------------------------------------------------------------------------
    GOSUB CHECK.DUP
RETURN
*--------------------------------------------------------------------------------------------------------
**********
CHECK.DUP:
**********
    AF = PRINT.CHQ.LIST.VERSIONS
    CALL DUP

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
