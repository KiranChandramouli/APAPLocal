SUBROUTINE REDO.STO.OVERRIDE.PARAM.VALIDATE
*-----------------------------------------------------------------------------
*DESCRIPTION : This routine is used to validate the REDO.STO.OVERRIDE.PARAM table fields
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* Revision History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*24.08.2010      SUDHARSANAN S      PACS00054326    INITIAL CREATION
* -----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.OVERRIDE
    $INSERT I_F.REDO.STO.OVERRIDE.PARAM

    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*----------
OPENFILES:
*----------
    FN.OVERRIDE = 'F.OVERRIDE'
    F.OVERRIDE = ''
    CALL OPF(FN.OVERRIDE,F.OVERRIDE)
RETURN
*---------
PROCESS:
*---------

    VAR.OVERRIDE.ID = R.NEW(STO.OVE.OVERRIDE.ID)
    CHANGE @VM TO @FM IN VAR.OVERRIDE.ID
    OVERRIDE.ID.CNT = DCOUNT(VAR.OVERRIDE.ID,@FM) ; CNT.LOOP  = 1

    LOOP
    WHILE CNT.LOOP LE OVERRIDE.ID.CNT
        Y.OVERRIDE.ID  = VAR.OVERRIDE.ID<CNT.LOOP>
        CALL CACHE.READ(FN.OVERRIDE, Y.OVERRIDE.ID, R.OVER.VALUES, OVR.ERR)
        Y.MESSAGE = R.OVER.VALUES<EB.OR.MESSAGE,1>
        R.NEW(STO.OVE.MESSAGE)<1,CNT.LOOP> = Y.MESSAGE
        CNT.LOOP += 1
    REPEAT
RETURN
*---------------------------------------------------------------------
END
