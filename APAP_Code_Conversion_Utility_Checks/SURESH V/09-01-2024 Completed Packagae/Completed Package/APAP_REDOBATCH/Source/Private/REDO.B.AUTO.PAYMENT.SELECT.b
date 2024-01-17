* @ValidationCode : MjotODQyNTI4MDMyOkNwMTI1MjoxNzAzMDc2NjIxNDA5OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 20 Dec 2023 18:20:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.AUTO.PAYMENT.SELECT
*------------------------------------------------------------------
** COMPANY NAME : APAP
* DEVELOPED BY : JEEVA T
* PROGRAM NAME : REDO.B.DIRECT.DEBIT.SELECT
*------------------------------------------------------------------
* Description : This is the update rotuine which will select all the customer
******************************************************************
*31-10-2011         JEEVAT             EB.LOOKUP select has been removed
*Modification
* Date                  who                   Reference
* 10-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 10-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*20/12/2023         Suresh             R22 Manual Conversion              CALL routine modified

*------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.AUTO.PAYMENT.COMMON
    
    $USING EB.Service ;*R22 Manual Conversion

    GOSUB ACCOUNT.SELECT
RETURN
*-----------------------------------------------------
ACCOUNT.SELECT:
*-----------------------------------------------------

    SEL.CMD.SR = "SELECT ":FN.REDO.DIRECT.DEBIT.ACCOUNTS
    CALL EB.READLIST(SEL.CMD.SR,SEL.LIST.SR,'',NO.REC,PGM.ERR)
*    CALL BATCH.BUILD.LIST('',SEL.LIST.SR)
    EB.Service.BatchBuildList('',SEL.LIST.SR) ;*R22 Manual Conversion

RETURN
END
