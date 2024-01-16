* @ValidationCode : MjotODc3Njg5MzM3OkNwMTI1MjoxNzAzMDc1NTc0MzEyOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 20 Dec 2023 18:02:54
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
SUBROUTINE REDO.B.AUTO.ITEM.REQ.SELECT

****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : JEEVA T
* Program Name  : REDO.B.AUTO.ITEM.REQ.SELECT
*-------------------------------------------------------------------------
* Description: This routine is a select routine to load all the necessary variables for the
* multi threaded process
*----------------------------------------------------------
* Linked with: Multi threaded batch routine REDO.B.STAFF.CUST.TRACK
* In parameter : None
* out parameter : CUST.ID
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                             DESCRIPTION
* 03-03-10      ODR-2009-10-0532                     Initial Creation
* Date                  who                   Reference
* 06-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 06-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*20/12/2023         Suresh                 R22 Manual Conversion   CALL routine modified

*------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.AUTO.ITEM.REQ.COMMON
    $INSERT I_F.REDO.ITEM.STOCK
    
    $USING EB.Service ;*R22 Manual Conversion

    SEL.CMD ='SELECT ':FN.REDO.ITEM.STOCK
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.IDS,SEL.RET)
    ID.LIST = SEL.LIST
*    CALL BATCH.BUILD.LIST('',ID.LIST)
    EB.Service.BatchBuildList('',ID.LIST) ;*R22 Manual Conversion

RETURN

END
