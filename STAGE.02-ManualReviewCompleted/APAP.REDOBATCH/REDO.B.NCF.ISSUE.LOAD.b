* @ValidationCode : MjotMjA4NzA5NTI3OTpDcDEyNTI6MTY4MTI4MTU0NDMzNjpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 12:09:04
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
SUBROUTINE REDO.B.NCF.ISSUE.LOAD
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This Routine will load all the common variables used in the routine REDO.B.NCF.ISSUE
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 25-MAR-2010        Prabhu.N       ODR-2009-10-0321     Initial Creation
* Date                   who                   Reference              
* 12-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - NO CHANGES
* 12-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*--------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.NCF.ISSUED
    $INSERT I_F.REDO.L.NCF.STATUS
    $INSERT I_F.REDO.L.NCF.UNMAPPED
    $INSERT I_REDO.B.NCF.ISSUE.COMMON

    GOSUB INIT
RETURN
*----
INIT:
*----
    FN.STMT.ENTRY='F.STMT.ENTRY'
    F.STMT.ENTRY =''
    CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)

    FN.CATEG.ENTRY='F.CATEG.ENTRY'
    F.CATEG.ENTRY=''
    CALL OPF(FN.CATEG.ENTRY,F.CATEG.ENTRY)

    FN.REDO.L.NCF.ISSUED='F.REDO.NCF.ISSUED'
    F.REDO.NCF.ISSUED=''
    CALL OPF(FN.REDO.L.NCF.ISSUED,F.REDO.L.NCF.ISSUED)

    FN.REDO.L.NCF.STATUS='F.REDO.L.NCF.STATUS'
    F.REDO.L.NCF.STATUS=''
    CALL OPF(FN.REDO.L.NCF.STATUS,F.REDO.L.NCF.STATUS)

    FN.REDO.L.NCF.UNMAPPED='F.REDO.L.NCF.UNMAPPED'
    F.REDO.L.NCF.UNMAPPED =''
    CALL OPF(FN.REDO.L.NCF.UNMAPPED,F.REDO.L.NCF.UNMAPPED)

    FN.REDO.L.NCF.STOCK='F.REDO.L.NCF.STOCK'
    F.REDO.L.NCF.STOCK=''
    CALL OPF(FN.REDO.L.NCF.STOCK,F.REDO.L.NCF.STOCK)

    FN.LOCKING='F.LOCKING'
    F.LOCKING=''
    CALL OPF(FN.LOCKING,F.LOCKING)

    LREF.APP='STMT.ENTRY'
    LREF.FIELDS='L.NCF.NO'
    LREF.POS=''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)

RETURN
END
