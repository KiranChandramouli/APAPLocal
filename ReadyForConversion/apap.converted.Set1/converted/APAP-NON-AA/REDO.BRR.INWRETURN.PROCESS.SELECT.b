SUBROUTINE REDO.BRR.INWRETURN.PROCESS.SELECT
*-----------------------------------------------------------------------------
* Description:
* This routine is a multithreaded routine to select the records in the mentioned applns..
*------------------------------------------------------------------------------------------
* * Input / Output
*
* --------------
* IN     : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP.
* DEVELOPED BY : NATCHIMUTHU
* PROGRAM NAME : REDO.B.INWRETURN.PROCESS.SELECT
* ODR          : ODR-2010-09-0148
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO            REFERENCE          DESCRIPTION
* 30.09.2010     NATCHIMUTHU     ODR-2010-09-0148   INITIAL CREATION
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.APAP.CLEARING.INWARD
    $INSERT I_F.REDO.MAPPING.TABLE
    $INSERT I_F.REDO.CLEARING.PROCESS
    $INSERT I_BATCH.FILES
    $INSERT I_REDO.BRR.INWRETURN.PROCESS.COMMON

    GOSUB PROCESS
RETURN

*********
PROCESS:
*********

    SEL.CMD= "SELECT ":FN.REDO.APAP.CLEARING.INWARD:" WITH STATUS EQ REJECTED AND WITH TRANS.DATE EQ ": TODAY
    CALL EB.READLIST(SEL.CMD,BUILD.LIST,'',Y.SEL.CNT,Y.ERR)
    CALL BATCH.BUILD.LIST('',BUILD.LIST)
RETURN
END
*-----------------------------------------------------------------------------------------------------------------------------------
