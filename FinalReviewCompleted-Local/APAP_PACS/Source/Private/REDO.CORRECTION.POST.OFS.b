* @ValidationCode : MjoxMjQ4NzM1OTQ0OkNwMTI1MjoxNjgxODkxNjg2NTAxOmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Apr 2023 13:38:06
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.PACS
SUBROUTINE REDO.CORRECTION.POST.OFS
*-----------------------------------------------------------
*Description: This is main line program to post OFS message for AA in case of doing the correction.
*             We are posting OFS, because in case if we pass value for a field from AAA>FIELD.NAME in browser
*             then system flushes all the existing values.
*
*-----------------------------------------------------------
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*19-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  F.READ to CACHE.READ , CONVERT into CHANGE
*19-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------





    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.OVERRIDE


    GOSUB OPEN.FILES
    GOSUB PROCESS
    CALL JOURNAL.UPDATE("")
RETURN
*-----------------------------------------------------------
OPEN.FILES:
*-----------------------------------------------------------

    FN.OVERRIDE = "F.OVERRIDE"
    F.OVERRIDE  = ""
    CALL OPF(FN.OVERRIDE,F.OVERRIDE)

RETURN
*-----------------------------------------------------------
PROCESS:
*-----------------------------------------------------------

    CALL CACHE.READ(FN.OVERRIDE, "REDO.AA.OFS", R.OVERRIDE, OVER.ERR) ;*R22 AUTO CODE CONVERSION
    Y.OFS.SOURCE  = R.OVERRIDE<EB.OR.MESSAGE,1,1>
    Y.APPLICATION = R.OVERRIDE<EB.OR.PREV.MESSAGE,1,1>
    Y.RECORD.ID   = R.OVERRIDE<EB.OR.PREV.MESSAGE,1,2>

    TEMPTIME = OCONV(TIME(),"MTS")
    TEMPTIME = TEMPTIME[1,5]
    CHANGE ':' TO '' IN TEMPTIME ;*R22 AUTO CODE CONVERSION
    CHECK.DATE = DATE()
    DATE.TIME = OCONV(CHECK.DATE,"DY2"):FMT(OCONV(CHECK.DATE,"DM"),"R%2"):FMT(OCONV(CHECK.DATE,"DD"),"R%2"):TEMPTIME
    R.OVERRIDE<EB.OR.PREV.MESSAGE,1,4> = OPERATOR:" - ":DATE.TIME
    IF Y.OFS.SOURCE AND Y.APPLICATION AND Y.RECORD.ID ELSE

        ERR.MSG = "Missing OFS.SOURCE/APPLICATION/RECORD.ID"
        R.OVERRIDE<EB.OR.PREV.MESSAGE,1,5> = ERR.MSG
        CALL F.WRITE(FN.OVERRIDE,"REDO.AA.OFS",R.OVERRIDE)
        RETURN
    END


    IF R.OVERRIDE<EB.OR.PREV.MESSAGE,1,3> EQ "PROCESSED" THEN
        ERR.MSG = "Message processed already"
        R.OVERRIDE<EB.OR.PREV.MESSAGE,1,5> = ERR.MSG
        CALL F.WRITE(FN.OVERRIDE,"REDO.AA.OFS",R.OVERRIDE)
        RETURN
    END

    APP.NAME      = FIELD(Y.APPLICATION,',',1)
    OFSFUNCT      = 'I'
    PROCESS       = 'PROCESS'
    OFSVERSION    = Y.APPLICATION
    GTSMODE       = ''
    TRANSACTION.ID=Y.RECORD.ID
    OFSRECORD     = ''
    OFS.MSG.ID    = ''
    OFS.ERR       = ''
    NO.OF.AUTH    = 0
    R.AAA         = ""
    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,GTSMODE,NO.OF.AUTH,TRANSACTION.ID,R.AAA,OFSRECORD)
    OFS.MSG.ID = ''
    OFS.SRC    = Y.OFS.SOURCE
    OPTIONS    = ''
    CALL OFS.POST.MESSAGE(OFSRECORD,OFS.MSG.ID,OFS.SRC,OPTIONS)

    R.OVERRIDE<EB.OR.PREV.MESSAGE,1,3> = "PROCESSED"
    R.OVERRIDE<EB.OR.PREV.MESSAGE,1,5> = "Messaged posted successfully -":OFS.MSG.ID
    CALL F.WRITE(FN.OVERRIDE,"REDO.AA.OFS",R.OVERRIDE)

RETURN
END
