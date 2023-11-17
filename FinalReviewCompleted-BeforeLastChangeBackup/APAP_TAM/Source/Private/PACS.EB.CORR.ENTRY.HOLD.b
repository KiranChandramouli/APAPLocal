* @ValidationCode : MjoxODI1OTM2MTI1OkNwMTI1MjoxNjg0NDkxMDI2OTg1OklUU1M6LTE6LTE6NzQxOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 741
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE PACS.EB.CORR.ENTRY.HOLD
*-----------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                       DESCRIPTION
*24-04-2023            Conversion Tool             R22 Auto Code conversion               = TO EQ
*24-04-2023              Samaran T                R22 Manual Code conversion              No Changes
*----------------------------------------------------------------------------------------------------------------------

*-------------------------------------------------------------------------------------
* Routine to delete ENTRY.HOLD based on input file FT.IDS.
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.STMT.ENTRY
    $INSERT I_SCREEN.VARIABLES
*-------------------------------------------------------------------------------------

    GOSUB GET.INPUT
    GOSUB OPEN.FILES
    GOSUB MAIN.PROCESS

RETURN
*-------------------------------------------------------------------------------------
GET.INPUT:
*-------------------------------------------------------------------------------------

***FT.LIST = "FT21077D16H4"

    FN.SL = "&SAVEDLISTS&"
    F.SL = ""
    CALL OPF(FN.SL, F.SL)

    SL.ID = "SL.PROB.FT"

    CALL F.READ(FN.SL, SL.ID, R.SL, F.SL, SL.ERR)

RETURN
*-------------------------------------------------------------------------------------
MAIN.PROCESS:
*-------------------------------------------------------------------------------------

    CORRECT = 1
    CNT = 0
    LOOP
        REMOVE FT.ID FROM R.SL SETTING FT.POS
    WHILE FT.ID : FT.POS
        HOLD.ID = 'FT':FT.ID

        CALL F.READ(FN.ENTRY.HOLD,HOLD.ID,R.ENTRY.HOLD,FV.ENTRY.HOLD,READ.ERR)
        CNT += 1
        GOSUB GET.SYS.ID
        GOSUB CHECK.OR.CORR.REC
    REPEAT


RETURN
*-------------------------------------------------------------------------------------
CHECK.OR.CORR.REC:
*-------------------------------------------------------------------------------------

    IF LAST.APP NE APP AND APP NE 'LOCAL' THEN    ;* This will enable me to delete 'LOCAL' entries too
        APPLICATION = APP
        V$FUNCTION = 'GET.DEF'
        CALL EB.EXECUTE.APPLICATION(APPLICATION)  ;* Initialized 'V' variable
        LAST.APP = APPLICATION
        FN.FILE$NAU = 'F.':APPLICATION:'$NAU'
        F.FILE$NAU  = ''
        CALL OPF(FN.FILE$NAU,F.FILE$NAU)
    END

    IF APP EQ 'LOCAL' THEN    ;*R22 AUTO CODE CONVERSION
        MAT R.NEW = ''
        V         = 11        ;* Minimal Req
    END ELSE
        MATREADU R.NEW FROM F.FILE$NAU,CONT.ID ELSE         ;* lock it
            MAT R.NEW = ''
        END
    END

    GOSUB RESTORE.ACCT.BAL

    RELEASE F.FILE$NAU,CONT.ID          ;* Release the lock

RETURN
*-------------------------------------------------------------------------------------
OPEN.FILES:
*-------------------------------------------------------------------------------------


    FN.ENTRY.HOLD='F.ENTRY.HOLD'; FV.ENTRY.HOLD=''
    CALL OPF(FN.ENTRY.HOLD,FV.ENTRY.HOLD)


RETURN

*-------------------------------------------------------------------------------------
GET.SYS.ID:
*-------------------------------------------------------------------------------------

    SYS.ID = ''

    SYS.ID  = 'FT'
    CONT.ID =  FT.ID
    APP     = 'FUNDS.TRANSFER'

RETURN
*-------------------------------------------------------------------------------------
RESTORE.ACCT.BAL:
*-------------------------------------------------------------------------------------


    ID.NEW = CONT.ID

    CALL EB.ACCOUNTING(SYS.ID,'DEL','','')        ;* This will release the balance as well as currency position
    CALL JOURNAL.UPDATE(ID.NEW)         ;* Update the same

RETURN
*-------------------------------------------------------------------------------------
PROGRAM.RETURN:
*-------------------------------------------------------------------------------------

RETURN TO PROGRAM.RETURN

RETURN
*-------------------------------------------------------------------------------------
END
