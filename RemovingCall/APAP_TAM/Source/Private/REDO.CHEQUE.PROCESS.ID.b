* @ValidationCode : MjotODE3NjI1NTI1OkNwMTI1MjoxNjg0ODQyMDg3MDAwOklUU1M6LTE6LTE6NDg3OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 17:11:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 487
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.CHEQUE.PROCESS.ID
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to check the ID value for the table REDO.TELLER.PROCESS
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : JEEVA T
* PROGRAM NAME : REDO.CHEQUE.PROCESS.ID
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
*23-AUG-2011     JEEVA T                 N.11             INTITLA CREATION
* Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*05/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*05/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
* ----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.CHEQUE.PROCESS
    $INSERT I_F.LOCKING
    GOSUB INIT
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
INIT:
    FN.LOCKING='F.LOCKING'
    F.LOCKING=''
    CALL OPF(FN.LOCKING,F.LOCKING)

    FN.REDO.CHEQUE.PROCESS = 'F.REDO.CHEQUE.PROCESS'
    F.REDO.CHEQUE.PROCESS = ''
    CALL OPF(FN.REDO.CHEQUE.PROCESS,F.REDO.CHEQUE.PROCESS)

    LOCK.FLUSH=''

RETURN
*----------------------------------------------------------------------------
PROCESS:

    LOCK.ID = FN.REDO.CHEQUE.PROCESS
    IF V$FUNCTION EQ 'I' THEN
        R.LOCKING = ''
        LOCK.ERR = ''
        CALL F.READU(FN.LOCKING,LOCK.ID,R.LOCKING,F.LOCKING,LOCK.ERR,'')
        Y.CONTENT = R.LOCKING<EB.LOK.CONTENT>
        Y.REMARK =R.LOCKING<EB.LOK.REMARK>
        IF Y.CONTENT EQ '' THEN
            Y.SEQ='001'
            ID.NEW='TT':TODAY:Y.SEQ
            R.LOCKING<EB.LOK.CONTENT> = ID.NEW
            R.LOCKING<EB.LOK.REMARK> = TODAY
            CALL F.WRITE(FN.LOCKING,LOCK.ID,R.LOCKING)
        END ELSE
            LOCATE TODAY IN Y.REMARK SETTING POS ELSE
                Y.SEQ='001'
                ID.NEW='TT':TODAY:Y.SEQ
                R.LOCKING<EB.LOK.CONTENT> = ID.NEW
                R.LOCKING<EB.LOK.REMARK> = TODAY
                CALL F.WRITE(FN.LOCKING,LOCK.ID,R.LOCKING)
            END
        END
    END
RETURN
*------------------------------------------------------------------------------
END
