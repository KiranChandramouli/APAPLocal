* @ValidationCode : MjotOTUzNDcyNjA1OkNwMTI1MjoxNjg0ODU0NDAwMTIwOklUU1M6LTE6LTE6NDgwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 480
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.UPD.FT.RETRY.TABLE(ARR.ID)
*----------------------------------------------------------------------------------------------------
*DESCRIPTION:
*             This routine is the record routine of the batch job REDO.B.UPD.FT.RETRY.TABLE
* This routine updates the local table REDO.STO.PENDING.RESUBMISSION, by deleting the record
* if FT retry is successful
* ---------------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  :
*  ARR..ID - Arrangement id
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 07-JUN-2010   N.Satheesh Kumar  TAM-ODR-2009-10-0331   Initial Creation
* Date                   who                   Reference              
* 13-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND VM TO @VM AND ++ TO += 1 
* 13-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.RESUBMIT.FT.DET
    $INSERT I_REDO.B.UPD.FT.RETRY.TABLE.COMMON

    GOSUB PROCESS
    GOSUB UPDATE.CONCAT.FILES
RETURN

*-------
PROCESS:
*-------
*---------------------------------------------------------------
* This section get the FT IDS for which FT retry is successful
*---------------------------------------------------------------

    DEL.FT.IDS = ''
    CALL F.READ(FN.REDO.RESUBMIT.FT.DET,ARR.ID,R.REDO.RESUBMIT.FT.DET,F.REDO.RESUBMIT.FT.DET,FT.RESUB.ERR)
    RESUB.FT.IDS = R.REDO.RESUBMIT.FT.DET<REDO.RESUB.DET.FT.ID>
    RESUB.OFS.MSG.IDS = R.REDO.RESUBMIT.FT.DET<REDO.RESUB.DET.OFS.MSG.ID>
    RESUB.FT.CNT = 0

    LOOP
        RESUB.FT.CNT += 1
        REMOVE RESUB.FT.ID FROM RESUB.FT.IDS SETTING RESUB.FT.POS
    WHILE RESUB.FT.ID:RESUB.FT.POS
        OFS.MSG.ID = RESUB.OFS.MSG.IDS<1,RESUB.FT.CNT>
        IF OFS.MSG.ID NE '' THEN
            OFS.RES.ID = OFS.MSG.ID:'.1'
            CALL F.READ(FN.OFS.RESPONSE.QUEUE,OFS.RES.ID,R.OFS.RESPONSE.QUEUE,F.OFS.RESPONSE.QUEUE,OFS.RES.ERR)
            IF R.OFS.RESPONSE.QUEUE<1> EQ  1 THEN
                DEL.FT.IDS<-1> = RESUB.FT.ID
            END ELSE
                R.REDO.RESUBMIT.FT.DET<REDO.RESUB.DET.OFS.MSG.ID,RESUB.FT.CNT> = ''
            END
        END
    REPEAT
RETURN

*-------------------
UPDATE.CONCAT.FILES:
*-------------------
*---------------------------------------
* This section updates the concat tables
*---------------------------------------

    RESUB.FT.IDS = RESUB.FT.IDS
    RESUB.FT.ID.CNT = DCOUNT(RESUB.FT.IDS,@VM)
    DEL.FT.ID.CNT = DCOUNT(DEL.FT.IDS,@FM)

    LOOP
        REMOVE DEL.FT.ID FROM DEL.FT.IDS SETTING DEL.FT.ID.POS
    WHILE DEL.FT.ID:DEL.FT.ID.POS
        LOCATE DEL.FT.ID IN RESUB.FT.IDS<1,1> SETTING DEL.POS THEN
            DEL R.REDO.RESUBMIT.FT.DET<REDO.RESUB.DET.FT.ID,DEL.POS>
            DEL R.REDO.RESUBMIT.FT.DET<REDO.RESUB.DET.DATE,DEL.POS>
            DEL R.REDO.RESUBMIT.FT.DET<REDO.RESUB.DET.BILL.AMT,DEL.POS>
            DEL R.REDO.RESUBMIT.FT.DET<REDO.RESUB.DET.OFS.MSG.ID,DEL.POS>
            DEL RESUB.FT.IDS<1,DEL.POS>
            CALL F.DELETE(FN.REDO.STO.PENDING.RESUBMISSION,DEL.FT.ID)
        END
    REPEAT

    IF RESUB.FT.ID.CNT NE DEL.FT.ID.CNT THEN
        CALL F.WRITE(FN.REDO.RESUBMIT.FT.DET,ARR.ID,R.REDO.RESUBMIT.FT.DET)
    END ELSE
        CALL F.DELETE(FN.REDO.RESUBMIT.FT.DET,ARR.ID)
    END
RETURN

END
