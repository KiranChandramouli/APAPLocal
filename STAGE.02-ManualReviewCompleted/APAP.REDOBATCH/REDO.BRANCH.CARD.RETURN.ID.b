* @ValidationCode : MjotMTQ5OTE5NTU0MTpDcDEyNTI6MTY4MTcxMDgxMTQ1NjpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 17 Apr 2023 11:23:31
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
SUBROUTINE REDO.BRANCH.CARD.RETURN.ID
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.REQUEST.ID
*--------------------------------------------------------------------------------------------------------
*Description  : This is a ID routine to to fetch next sequence no from F.LOCKING
*Linked With  : REDO.CARD.REQUEST
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 23 Jul 2010    Mohammed Anies K      ODR-2010-03-0400        Initial Creation
* 21-Jan-2010    Kavitha S             ODR-2010-03-0400        Code change as per CR
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 17-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 17-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.COMPANY
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********

    IF NOT(RUNNING.UNDER.BATCH) THEN
        IF GTSACTIVE THEN
            IF OFS$OPERATION EQ 'BUILD' THEN
                GOSUB PROCESS.PARA
                RETURN
            END
        END ELSE
            GOSUB PROCESS.PARA
        END
    END ELSE
        GOSUB PROCESS.PARA
    END
RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* Main processing section
    E = ''

    IF V$FUNCTION EQ 'I' THEN
        ID.NEW = ID.COMPANY:"-":TODAY
    END
RETURN
*-------------------------------------------------------------------------
END
