* @ValidationCode : MjoxNTMzNzA2NTgzOkNwMTI1MjoxNzA0NDI5NzI2Mzc5OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Jan 2024 10:12:06
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
SUBROUTINE REDO.B.PURGE.CARDS.SELECT
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.B.PURGE.CARDS.SELECT
*--------------------------------------------------------------------------------------------------------
*Description       :  This is a Multi threaded Select Routine Which is used to select LATAM.CARD.ORDER table
*                     with CARD.STATUS equal to '93'
*In Parameter      :
*Out Parameter     :
*Files  Used       :
*
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
*  30/07/2010       REKHA S            ODR-2010-03-0400 B166      Initial Creation
* 04-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*
*18/01/2024         Suresh          R22 UTILITY AUTO CONVERSION   CALL routine Modified
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.LATAM.CARD.ORDER
    $INSERT I_REDO.B.PURGE.CARDS.COMMON
    $USING EB.Service

    GOSUB PROCESS
RETURN
 
********
PROCESS:
********
    SEL.CMD = 'SELECT ':FN.LATAM.CARD.ORDER:' WITH CARD.STATUS EQ 93'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,Y.RET.CODE)

*    CALL BATCH.BUILD.LIST('',SEL.LIST)
    EB.Service.BatchBuildList('',SEL.LIST);* R22 UTILITY AUTO CONVERSION

RETURN
END
