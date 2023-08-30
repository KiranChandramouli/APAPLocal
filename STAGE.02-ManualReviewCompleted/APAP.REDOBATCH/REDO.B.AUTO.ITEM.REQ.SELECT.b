* @ValidationCode : Mjo1MTQwOTUzODU6Q3AxMjUyOjE2ODA3ODE0NjYxNzc6SVRTUzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 17:14:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
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
* 06-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 06-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.AUTO.ITEM.REQ.COMMON
    $INSERT I_F.REDO.ITEM.STOCK

    SEL.CMD ='SELECT ':FN.REDO.ITEM.STOCK
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.IDS,SEL.RET)
    ID.LIST = SEL.LIST
    CALL BATCH.BUILD.LIST('',ID.LIST)

RETURN

END
