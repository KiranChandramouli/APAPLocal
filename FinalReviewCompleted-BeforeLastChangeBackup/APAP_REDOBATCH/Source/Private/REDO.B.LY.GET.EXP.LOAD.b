* @ValidationCode : MjotNzUyNzUxMDY1OkNwMTI1MjoxNjgwNzkwMTA5Mzk5OklUU1M6LTE6LTE6MzkzOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 19:38:29
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 393
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.LY.GET.EXP.LOAD
*-----------------------------------------------------------------------------
* Initialize COMMON variables and Open required files
*
*-----------------------------------------------------------------------------
* Modification History:
*                      2011-06-21 : avelasco@temenos.com
*                                   First version
*                      2013-11-29 : rmondragon@temenos.com
*                                   Update to get next working date needed for
*                                   SELECT routine.
* DATE              WHO                REFERENCE                 DESCRIPTION
* 04-APR-2023     Conversion tool   R22 Auto conversion	    F.READ to CACHE.READ, F.DATES to DATES
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_REDO.B.LY.GET.EXP.COMMON
*-----------------------------------------------------------------------------

    G.DATE = ''
    I.DATE = DATE()
    CALL DIETER.DATE(G.DATE,I.DATE,'')

* Open files to be used in the XX routine as well as standard variables.
* REDO.LY.PROGRAM
    FN.REDO.LY.PROGRAM = 'F.REDO.LY.PROGRAM'
    F.REDO.LY.PROGRAM = ''
    CALL OPF(FN.REDO.LY.PROGRAM,F.REDO.LY.PROGRAM)

* REDO.LY.POINTS.TOT
    FN.REDO.LY.POINTS = 'F.REDO.LY.POINTS'
    F.REDO.LY.POINTS  = ''
    CALL OPF(FN.REDO.LY.POINTS,F.REDO.LY.POINTS)

* REDO.LY.POINTS.TOT
    FN.REDO.LY.POINTS.TOT = 'F.REDO.LY.POINTS.TOT'
    F.REDO.LY.POINTS.TOT  = ''
    CALL OPF(FN.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT)

* DATES
    FN.DATES = 'F.DATES'
    F.DATES = ''
    CALL OPF(FN.DATES,F.DATES)

    R.REC = ''; DATES.ERR = ''
    ID.TO.CHECK = ID.COMPANY:'-COB'
    CALL CACHE.READ(FN.DATES, ID.TO.CHECK, R.REC, DATES.ERR) ;*R22 Auto conversion
    IF R.REC THEN
        Y.NEXT.WDATE = R.REC<EB.DAT.NEXT.WORKING.DAY>
    END

RETURN
*-----------------------------------------------------------------------------
END
