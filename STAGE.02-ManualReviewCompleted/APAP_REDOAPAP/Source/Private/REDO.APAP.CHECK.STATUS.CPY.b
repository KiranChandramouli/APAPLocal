* @ValidationCode : MjotMTA2Njc0NzE4OTpDcDEyNTI6MTY4NDgzNjAzNDQ1NTpJVFNTOi0xOi0xOi03OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -7
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.CHECK.STATUS.CPY
*********************************************************************************************************
* Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By      : Temenos Application Management
* Program   Name    : REDO.NOFILE.PYMT.STOP.ACCT
*--------------------------------------------------------------------------------------------------------
* Description       : This routine is used to increase the count based upon the user's input

* Linked With       :
* In  Parameter     : Y.FINAL.ARR
* Out Parameter     : Y.FINAL.ARR
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                  Reference                  Description
*   ------             -----                 -----------                -----------
* 21-DEC-2010      JEYACHANDRAN S          ODR-2010-03-0159           Initial Creation
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*11-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*11-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------



*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    GOSUB INIT
RETURN
*---------
INIT:

    Y.LAST = ''
    Y.FIRST = ''

    Y.FIRST = FIELD(O.DATA,"-",1)
    Y.LAST = FIELD( O.DATA,"-",2)
    IF Y.FIRST EQ Y.LAST THEN
        O.DATA = Y.FIRST
    END

RETURN

*****************************************************************************************************************************
END
