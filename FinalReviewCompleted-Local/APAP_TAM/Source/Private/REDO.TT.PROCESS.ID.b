* @ValidationCode : MjotOTM4NTk4Njk6Q3AxMjUyOjE2ODExMDk4NDMzMjk6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Apr 2023 12:27:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.TT.PROCESS.ID
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to check the ID value for the table REDO.PART.TT.PROCESS
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : JEEVA T
* PROGRAM NAME : REDO.TT.PROCESS.ID
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* 11.11.2010      JEEVA T         ODR-2010-08-0017  INITIAL CREATION
* 10.04.2023     Conversion Tool       R22            Auto Conversion     - No changes
* 10.04.2023     Shanmugapriya M       R22            Manual Conversion   - No changes
*
* ----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.TT.PROCESS
    $INSERT I_F.LOCKING
    GOSUB INIT
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
INIT:
    FN.LOCKING='F.LOCKING'
    F.LOCKING=''
    CALL OPF(FN.LOCKING,F.LOCKING)
    LOCK.FLUSH=''

RETURN
*----------------------------------------------------------------------------
PROCESS:

    IF V$FUNCTION EQ 'I' THEN
        R.LOCKING = ''
        LOCK.ERR = ''
        LOCK.ID='FBNK.REDO.TT.PROCESS'
        CALL F.READU(FN.LOCKING,LOCK.ID,R.LOCKING,F.LOCKING,LOCK.ERR,'')
        Y.CONTENT = R.LOCKING<EB.LOK.CONTENT>
        Y.REMARK =R.LOCKING<EB.LOK.REMARK>
        IF Y.CONTENT EQ '' THEN
            Y.SEQ='001'
            ID.NEW='TT':TODAY:Y.SEQ
            R.LOCKING<EB.LOK.CONTENT> = ID.NEW
            R.LOCKING<EB.LOK.REMARK> = TODAY
            CALL LOG.WRITE(FN.LOCKING,LOCK.ID,R.LOCKING,LOCK.FLUSH)
        END ELSE
            LOCATE TODAY IN Y.REMARK SETTING POS ELSE
                Y.SEQ='001'
                ID.NEW='TT':TODAY:Y.SEQ
                R.LOCKING<EB.LOK.CONTENT> = ID.NEW
                R.LOCKING<EB.LOK.REMARK> = TODAY
                CALL LOG.WRITE(FN.LOCKING,LOCK.ID,R.LOCKING,LOCK.FLUSH)
            END
        END
    END
RETURN
*------------------------------------------------------------------------------
END
