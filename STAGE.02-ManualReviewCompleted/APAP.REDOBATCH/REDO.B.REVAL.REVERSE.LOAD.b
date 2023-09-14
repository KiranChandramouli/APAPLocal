* @ValidationCode : Mjo3NDE2ODUzMDI6Q3AxMjUyOjE2ODEzNTg1NTkzODU6SVRTUzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Apr 2023 09:32:39
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.REVAL.REVERSE.LOAD
*---------------------------------------------------------------------------------------------
*DESCRIPTION
*------------
*
*.LOAD routine for the batch program EVB.B.GAAP.REVAL.REVERSE
*
*---------------------------------------------------------------------------------------------
* Input / Output
* --------------
* IN     :
* OUT    :
*
* Dependencies
* ------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* CHANGE REQUEST / DEVELOPMENT REF:
*---------------------------------------------------------------------------------------------
* Revision History
* ----------------
* Date          Who              Reference                 Description
* 01-12-2011   Victor Panchi                         Multibooking
* 01-12-2011   Marcelo Gud    Multibooking
*---------------------------------------------------------------------------------------------
* 30/08/2016 - Mod1 - Eashwar ITSS
*            - Changes made to select the details from RE.SPEC.ENT.LWORK.DAY instead of RE.CONSOL.SPEC.ENTRY
* Date                  who                   Reference              
* 13-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 13-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COMPANY
    $INSERT I_F.RE.CONSOL.SPEC.ENTRY
    $INSERT I_F.CONSOLIDATE.COND
    $INSERT I_REDO.B.REVAL.REVERSE.COMMON
    $INSERT I_F.REDO.H.REVALUATION.PARAM
    $INSERT I_F.REDO.L.REVAL.FCY.PROD.POS

    GOSUB INITIALISE
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

*--------------------------------------------------------------------------------
INITIALISE:
*--------------------------------------------------------------------------------
*Initialising the variables.
    FN.REVAL.PARAM = 'F.REDO.H.REVALUATION.PARAM'
    F.REVAL.PARAM = ''
    FN.SPEC.ENTRY = 'F.RE.CONSOL.SPEC.ENTRY'
    F.SPEC.ENTRY = ''

    FN.EVB.L.GAAP.REVAL.FCY.PROD.POS = 'F.REDO.L.REVAL.FCY.PROD.POS'
    F.EVB.L.GAAP.REVAL.FCY.PROD.POS = ''

    FN.CONSOLIDATE.COND = 'F.CONSOLIDATE.COND'
    F.CONSOLIDATE.COND= ''

* Mod1 S
    FN.RE.SPEC.ENT.LWORK.DAY = 'F.RE.SPEC.ENT.LWORK.DAY'
    F.RE.SPEC.ENT.LWORK.DAY = ''
* Mod1 E

    Y.COUNT = ''
    R.REVAL.PARAM = ''
    REVAL.ERROR = ''
    Y.START.RANGE.ARR = ''
    Y.END.RANGE.ARR = ''
    Y.PL.CATEG = ''
    Y.REV.PL.CATEG = ''
    Y.SYS.ID = ''
    Y.ID.CSE = 'ASSET&LIAB'
RETURN

*--------------------------------------------------------------------------------
OPENFILES:
*--------------------------------------------------------------------------------
*Opening the needed files.
    CALL OPF(FN.REVAL.PARAM,F.REVAL.PARAM)
    CALL OPF(FN.SPEC.ENTRY,F.SPEC.ENTRY)
    CALL OPF(FN.CONSOLIDATE.COND,F.CONSOLIDATE.COND)
    CALL OPF(FN.EVB.L.GAAP.REVAL.FCY.PROD.POS,F.EVB.L.GAAP.REVAL.FCY.PROD.POS)

* Mod1 S
    CALL OPF(FN.RE.SPEC.ENT.LWORK.DAY,F.RE.SPEC.ENT.LWORK.DAY)
* Mod1 E
RETURN

*--------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------
*This reads the file EVB.H.GAAP.REVALUATION.PARAM with the id as ID.COMPANY
    REVAL.ID = ID.COMPANY
* TODO LUEGO DESCOMENTAR ESTE Y DESCOMETAR EL DE ABAJO CALL CACHE.READ(FN.REVAL.PARAM,REVAL.ID,R.REVAL.PARAM,REVAL.ERROR)
*CALL F.READ(FN.REVAL.PARAM,REVAL.ID,R.REVAL.PARAM,F.REVAL.PARAM,REVAL.ERROR) ;*Tus Start
    CALL CACHE.READ(FN.REVAL.PARAM,REVAL.ID,R.REVAL.PARAM,REVAL.ERROR)          ;*Tus End
    Y.START.RANGE.ARR = R.REVAL.PARAM<REVAL.PARM.START.PRD.RANGE>
    Y.END.RANGE.ARR = R.REVAL.PARAM<REVAL.PARM.END.PRD.RANGE>
    Y.PL.CATEG = R.REVAL.PARAM<REVAL.PARM.PL.CATEGORY>
    Y.REV.PL.CATEG = R.REVAL.PARAM<REVAL.PARM.REV.PL.CATEGORY>
    Y.SYS.ID = R.REVAL.PARAM<REVAL.PARM.ENTRY.SYSTEM.ID>


* lISTA DE REGISTROS A NO TOMAR EN CUENTA EN RE.CONSOL.SPEC.ENTRY
* Mod2 JLOBOS
* Change of the validation form to take the contingent list from re.types instead of using R.CONSOLIDATE.COND<RE.CON.FWD.REV.TYPE>
    CALL RE.TYPES("ALL.CB",Y.LIST.CONSOLIDATE.COND)
*    CALL CACHE.READ(FN.CONSOLIDATE.COND,Y.ID.CSE,R.CONSOLIDATE.COND,RCSE.ERROR)
*    Y.LIST.CONSOLIDATE.COND = R.CONSOLIDATE.COND<RE.CON.FWD.REV.TYPE>
*    Y.LIST.CONSOLIDATE.COND = CHANGE(Y.LIST.CONSOLIDATE.COND, SM, FM)
* End Mod2
RETURN

*--------------------------------------------------------------------------------
END
