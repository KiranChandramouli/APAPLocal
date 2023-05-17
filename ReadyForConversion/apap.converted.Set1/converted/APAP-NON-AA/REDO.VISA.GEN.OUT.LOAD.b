SUBROUTINE  REDO.VISA.GEN.OUT.LOAD
*--------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.VISA.GEN.OUT.LOAD
*Date              : 07.12.2010
*-------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --STLMT.LINES--
* Out : --N/A--
*-----------------------------------------------------------------------------
* Revision History:
* -----------------
* Date                   Name                   Reference               Version
* -------                ----                   ----------              --------
*07/12/2010      saktharrasool@temenos.com   ODR-2010-08-0469       Initial Version
*------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.VISA.STLMT.PARAM
    $INSERT I_REDO.VISA.GEN.CHGBCK.OUT.COMMON
*$INCLUDE TAM.BP I_REDO.VISA.GEN.OUT.COMMON


    GOSUB OPEN.FILES
    GOSUB READ.FILES

RETURN


*------------------------------------------------------------------------------------
OPEN.FILES:
*------------------------------------------------------------------------------------
    FN.REDO.VISA.GEN.OUT='F.REDO.VISA.GEN.OUT'
    F.REDO.VISA.GEN.OUT=''
    CALL OPF(FN.REDO.VISA.GEN.OUT,F.REDO.VISA.GEN.OUT)

    FN.REDO.VISA.STLMT.MAPPING='F.REDO.VISA.STLMT.MAPPING'
    F.REDO.VISA.STLMT.MAPPING=''
    CALL OPF(FN.REDO.VISA.STLMT.MAPPING,F.REDO.VISA.STLMT.MAPPING)

    FN.REDO.VISA.OUTGOING='F.REDO.VISA.OUTGOING'
    F.REDO.VISA.OUTGOING=''
    CALL OPF(FN.REDO.VISA.OUTGOING,F.REDO.VISA.OUTGOING)

    FN.VISA.TC40.OUT.FILE='F.VISA.TC40.OUT.FILE'
    F.VISA.TC40.OUT.FILE=''
    CALL OPF(FN.VISA.TC40.OUT.FILE,F.VISA.TC40.OUT.FILE)

    FN.REDO.VISA.TC52.FILE='F.REDO.VISA.TC52.FILE'
    F.REDO.VISA.TC52.FILE=''
    CALL OPF(FN.REDO.VISA.TC52.FILE,F.REDO.VISA.TC52.FILE)

    FN.REDO.VISA.CHGBCK.LOG ='F.REDO.VISA.CHGBCK.LOG'
    F.REDO.VISA.CHGBCK.LOG =''
    CALL OPF(FN.REDO.VISA.CHGBCK.LOG,F.REDO.VISA.CHGBCK.LOG)

    FN.VISA.OUT.CHGBCK.LINES='F.VISA.OUT.CHGBCK.LINES'
    F.VISA.OUT.CHGBCK.LINES=''
    CALL OPF(FN.VISA.OUT.CHGBCK.LINES,F.VISA.OUT.CHGBCK.LINES)

    FN.REDO.FEECOLLECT='F.REDO.FEECOLLECT'
    F.REDO.FEECOLLECT=''
    CALL OPF(FN.REDO.FEECOLLECT,F.REDO.FEECOLLECT)

    FN.REDO.VISA.STLMT.PARAM='F.REDO.VISA.STLMT.PARAM'

RETURN

*------------------------------------------------------------------------------------
READ.FILES:
*------------------------------------------------------------------------------------

    REDO.ID='SYSTEM'
    CALL CACHE.READ(FN.REDO.VISA.STLMT.PARAM,REDO.ID,R.REDO.VISA.STLMT.PARAM,REDO.ERR)

    CALL F.READ(FN.REDO.VISA.STLMT.MAPPING,'050',R.REDO.VISA.STLMT.MAPPING.050,F.REDO.VISA.STLMT.MAPPING,MAP.ERR)
    CALL F.READ(FN.REDO.VISA.STLMT.MAPPING,'051',R.REDO.VISA.STLMT.MAPPING.051,F.REDO.VISA.STLMT.MAPPING,MAP.ERR)
    CALL F.READ(FN.REDO.VISA.STLMT.MAPPING,'070',R.REDO.VISA.STLMT.MAPPING.070,F.REDO.VISA.STLMT.MAPPING,MAP.ERR)
    CALL F.READ(FN.REDO.VISA.STLMT.MAPPING,'071',R.REDO.VISA.STLMT.MAPPING.071,F.REDO.VISA.STLMT.MAPPING,MAP.ERR)
    CALL F.READ(FN.REDO.VISA.STLMT.MAPPING,'074',R.REDO.VISA.STLMT.MAPPING.074,F.REDO.VISA.STLMT.MAPPING,MAP.ERR)
    CALL F.READ(FN.REDO.VISA.STLMT.MAPPING,'075',R.REDO.VISA.STLMT.MAPPING.075,F.REDO.VISA.STLMT.MAPPING,MAP.ERR)
RETURN
END
