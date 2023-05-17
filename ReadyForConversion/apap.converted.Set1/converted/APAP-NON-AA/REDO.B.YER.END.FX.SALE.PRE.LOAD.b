SUBROUTINE REDO.B.YER.END.FX.SALE.PRE.LOAD
*----------------------------------------------------------------------------------------------------------
* Description           : This load routine is used to load the details of Last Year Sales in Forex
*
* Developed By          : Amaravathi Krithika B
*
* Development Reference : RegN21
*
* Attached To           : BATCH>BNK/REDO.B.YER.END.FX.SALE
*
* Attached As           : Batch Routine
*----------------------------------------------------------------------------------------------------------
*------------------------
* Input Parameter:
* ---------------*
* Argument#1 : NA
* Argument#2 : NA
* Argument#3 : NA
*----------------------------------------------------------------------------------------------------------
*-----------------*
* Output Parameter:
* ----------------*
* Argument#4 : NA
* Argument#5 : NA
* Argument#6 : NA
*----------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*----------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*(RTC/TUT/PACS)                                        (YYYY-MM-DD)
*----------------------------------------------------------------------------------------------------------
*XXXX                   <<name of modifier>>                                 <<modification details goes he
*----------------------------------------------------------------------------------------------------------
* Include files

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.YER.END.FX.SALE.PRE.COMMON
    $INSERT I_F.FOREX
    $INSERT I_F.DATES
    $INSERT I_F.REDO.H.REPORTS.PARAM

    GOSUB INIT
    GOSUB PROCESS
RETURN
INIT:
*----
    FN.FX.HIST = ''
    F.FX.HIST = ''
    R.FX.HIST = ''
    Y.LST.WORKING = ''
    Y.YEAR = ''
    FN.REDO.FX.HIST.LIST = ''
    F.REDO.FX.HIST.LIST =''
    R.REDO.FX.HIST.LIST = ''
    FN.FOREX.LVE = ''
    F.FOREX.LVE = ''
    R.FOREX.LVE = ''
RETURN
PROCESS:
*------
*
    FN.FOREX.LVE = 'F.FOREX'
    F.FOREX.LVE = ''
    R.FOREX.LVE = ''
    CALL OPF(FN.FOREX.LVE,F.FOREX.LVE)
*
    FN.FX.HIST ='F.FOREX$HIS'
    F.FX.HIST = ''
    R.FX.HIST =''
    CALL OPF(FN.FX.HIST,F.FX.HIST)
*
    Y.LST.WORKING = R.DATES(EB.DAT.LAST.WORKING.DAY)
    Y.YEAR = "FX":Y.LST.WORKING[3,2]
*
    FN.REDO.FX.HIST.LIST  = 'F.REDO.FX.HIST.LIST'
    F.REDO.FX.HIST.LIST = ''
    R.REDO.FX.HIST.LIST = ''
    CALL OPF(FN.REDO.FX.HIST.LIST,F.REDO.FX.HIST.LIST)
*
RETURN
END
