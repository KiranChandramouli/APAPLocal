$PACKAGE APAP.TAM
SUBROUTINE REDO.H.REORDER.LEVEL.PROCESS
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
* PROGRAM NAME : REDO.GET.DEPT.CODE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* 11.11.2010      JEEVA T         ODR-2010-08-0017  INITIAL CREATION
** 11-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 11-04-2023 Skanda R22 Manual Conversion - No changes
* ----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.H.REORDER.LEVEL
    $INSERT I_F.REDO.H.MAIN.COMPANY
    $INSERT I_F.REDO.H.ITEM.DETAILS
    $INSERT I_F.LOCKING

    GOSUB PROCESS

RETURN

*----------------------------------------------------------------------------
PROCESS:

    FN.REDO.H.MAIN.COMPANY = 'F.REDO.H.MAIN.COMPANY'
    F.REDO.H.MAIN.COMPANY = ''
    CALL OPF(FN.REDO.H.MAIN.COMPANY,F.REDO.H.MAIN.COMPANY)

    FN.REDO.H.ITEM.DETAILS = 'F.REDO.H.ITEM.DETAILS'
    F.REDO.H.ITEM.DETAILS = ''
    CALL OPF(FN.REDO.H.ITEM.DETAILS,F.REDO.H.ITEM.DETAILS)

    Y.ID = ID.NEW

    CALL F.READ(FN.REDO.H.MAIN.COMPANY,Y.ID,R.REDO.H.MAIN.COMPANY,F.REDO.H.MAIN.COMPANY,Y.ERR)
    Y.DEP.CODE = R.REDO.H.MAIN.COMPANY<REDO.COM.CODE>
    Y.CODE.NEW = R.NEW(RE.ORD.CODE)
    Y.CNT = 1
    Y.COUNT = DCOUNT(Y.CODE.NEW,@VM)
    LOOP
    WHILE Y.CNT LE Y.COUNT
        LOCATE Y.CODE.NEW<1,Y.CNT> IN Y.DEP.CODE<1,1> SETTING POS ELSE
            AF = RE.ORD.CODE
            AV = Y.CNT
            ETEXT = 'AC-INVALID.DEPARTMENT.CODE'
            CALL STORE.END.ERROR
        END

        Y.CNT += 1 ;* R22 Auto conversion
    REPEAT
RETURN
*------------------------------------------------------------------------------
END
