*---------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.CUS.TAX.RETENTIONS.SELECT
*---------------------------------------------------------------------------------------------
*
* Description           : This is the Routine used to select the REDO.NCF.ISSUED Application with Based on the Date Value.

* Developed By          : Amaravathi Krithika B
*
* Development Reference : RegN11
*
* Attached To           : Batch - BNK/REDO.B.CUS.TAX.RETENTIONS
*
* Attached As           : Online Batch Routine to COB
*---------------------------------------------------------------------------------------------
* Input Parameter:
*----------------*
* Argument#1 : NA
*
*-----------------*
* Output Parameter:
*-----------------*
* Argument#4 : NA
*
*---------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*---------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*-----------------------------------------------------------------------------------------------------------------
* PACS00375393           Ashokkumar.V.P                 11/12/2014            New mapping changes - Rewritten the whole source.
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.STMT.ENTRY
    $INSERT TAM.BP I_REDO.B.CUS.TAX.RETENTIONS.COMMON
*

    GOSUB SELECT.PROCESS
    RETURN
*
SELECT.PROCESS:
*--------------
    TA.POSN = ''
    LOOP
        REMOVE TAX.AID FROM R.AC.SUB.ACC SETTING TA.POSN
    WHILE TAX.AID:TA.POSN
        STMT.ID.LIST = ''
        D.FIELDS = "ACCOUNT":FM:"BOOKING.DATE"
        D.LOGICAL.OPERANDS = "1":FM:"2"
        D.RANGE.AND.VALUE = TAX.AID:FM:Y.DATE.FROM:SM:Y.DATE.TO
        CALL E.STMT.ENQ.BY.CONCAT(STMT.ID.LIST)
        YGP.STMT.ID.LIST<-1> = STMT.ID.LIST
    REPEAT
    CALL BATCH.BUILD.LIST('',YGP.STMT.ID.LIST)

    RETURN
*---------------------------------------------------------------------------------------------
END
*---------------------------------------------------------------------------------------------
*
