SUBROUTINE DR.REG.REGN16.EXTRACT.LOAD
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.REGN16.EXTRACT
* Date           : 3-May-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the REDO.ISSUE.CLAIMS Details for each Customer
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author              Modification Description
* 21-08-2014      Ashokkumar           PACS00366332- Added auto date to run on monthly.
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.DATES
    $INSERT I_DR.REG.REGN16.EXTRACT.COMMON
    $INSERT I_F.DR.REG.REGN16.EXT.PARAM

    GOSUB INIT.PROCESS
    GOSUB DAYS.INIT
RETURN

*-----------------------------------------------------------------------------
INIT.PROCESS:
*-----------*

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.REDO.ISSUE.CLAIMS = 'F.REDO.ISSUE.CLAIMS'
    F.REDO.ISSUE.CLAIMS = ''
    CALL OPF(FN.REDO.ISSUE.CLAIMS,F.REDO.ISSUE.CLAIMS)

    FN.DR.REG.REGN16.WORKFILE = 'F.DR.REG.REGN16.WORKFILE'
    F.DR.REG.REGN16.WORKFILE = ''
    CALL OPF(FN.DR.REG.REGN16.WORKFILE,F.DR.REG.REGN16.WORKFILE)

    FN.RELATION = 'F.RELATION'
    F.RELATION = ''
    CALL OPF(FN.RELATION,F.RELATION)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.DR.REG.REGN16.EXT.PARAM = 'F.DR.REG.REGN16.EXT.PARAM'
    F.DR.REG.REGN16.EXT.PARAM = ''
    CALL OPF(FN.DR.REG.REGN16.EXT.PARAM,F.DR.REG.REGN16.EXT.PARAM)
    DR.REG.REGN16.EXT.PARAM.ERR = ''; R.DR.REG.REGN16.EXT.PARAM = ''
    CALL CACHE.READ(FN.DR.REG.REGN16.EXT.PARAM,'SYSTEM',R.DR.REG.REGN16.EXT.PARAM,DR.REG.REGN16.EXT.PARAM.ERR)
    REP.START.DATE = R.DR.REG.REGN16.EXT.PARAM<DR.REGN16.START.DATE>
    REP.END.DATE = R.DR.REG.REGN16.EXT.PARAM<DR.REGN16.END.DATE>
    TYPE.VAL = R.DR.REG.REGN16.EXT.PARAM<DR.REGN16.CLAIM.TYPE>

RETURN
*-----------------------------------------------------------------------------
DAYS.INIT:
**********

    YST.DAT = ''; YED.DAT = ''
    LAST.WRK.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
    YLST.MTH = LAST.WRK.DATE
    BEGIN CASE
        CASE LAST.WRK.DATE[5,2] EQ '03'
            YST.DAT = YLST.MTH[1,4]:'0101'
            YED.DAT = YLST.MTH[1,4]:'0331'
        CASE LAST.WRK.DATE[5,2] EQ '06'
            YST.DAT = YLST.MTH[1,4]:'0401'
            YED.DAT = YLST.MTH[1,4]:'0630'
        CASE LAST.WRK.DATE[5,2] EQ '09'
            YST.DAT = YLST.MTH[1,4]:'0701'
            YED.DAT = YLST.MTH[1,4]:'0930'
        CASE LAST.WRK.DATE[5,2] EQ '12'
            YST.DAT = YLST.MTH[1,4]:'1001'
            YED.DAT = YLST.MTH[1,4]:'1231'
        CASE 1
            YST.DAT = LAST.WRK.DATE[1,6]:'01'
            YED.DAT = LAST.WRK.DATE
    END CASE

    IF REP.START.DATE EQ '' AND REP.END.DATE EQ '' THEN
        REP.START.DATE = YST.DAT
        REP.END.DATE = YED.DAT
    END

RETURN

END
