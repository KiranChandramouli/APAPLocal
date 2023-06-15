* @ValidationCode : MjotNjc1NDQxMTQ5OkNwMTI1MjoxNjgyNDEyMzI4NjY4OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.AUTH.STO.OVERRIDE.PARAM
*---------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*----------------------------------------------------------------------------------------
* Revision History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*24.08.2010      SUDHARSANAN S      PACS00054326    INITIAL CREATION
* 06-04-2023	CONVERSION TOOL		AUTO R22 CODE CONVERSION	 FM to @FM, VM to @VM
* 06-04-2023	MUTHUKUMAR M		MANUAL R22 CODE CONVERSION	 NO CHANGE
* ---------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.OVERRIDE
    $INSERT I_F.REDO.STO.OVERRIDE.PARAM

    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*-----------
OPENFILES:
*-----------
    FN.REDO.STO.OVERRIDE.PARAM = 'F.REDO.STO.OVERRIDE.PARAM'
    STO.PARAM.ID = 'SYSTEM'
    CALL CACHE.READ(FN.REDO.STO.OVERRIDE.PARAM,STO.PARAM.ID,R.STO.OVERRIDE.PARAM,STO.ERR)
RETURN
*-----------
PROCESS:
*-----------
    Y.OVERRIDE.ID = R.STO.OVERRIDE.PARAM<STO.OVE.OVERRIDE.ID>
    CHANGE @VM TO @FM IN Y.OVERRIDE.ID
    VAR.OVERRIDE.ID = ID.NEW
    VAR.MESSAGE.NEW = R.NEW(EB.OR.MESSAGE)
    VAR.MESSAGE.OLD = R.OLD(EB.OR.MESSAGE)
    IF VAR.MESSAGE.NEW NE VAR.MESSAGE.OLD THEN
        LOCATE VAR.OVERRIDE.ID IN Y.OVERRIDE.ID SETTING POS THEN
            R.STO.OVERRIDE.PARAM<STO.OVE.MESSAGE,POS> = VAR.MESSAGE.NEW<1,1>
            CALL F.WRITE(FN.REDO.STO.OVERRIDE.PARAM,STO.PARAM.ID,R.STO.OVERRIDE.PARAM)
        END
    END
RETURN
*----------------------------------------------------------------------------------------
END
