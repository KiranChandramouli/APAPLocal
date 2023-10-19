* @ValidationCode : MjotMTUzOTY2ODE4NTpDcDEyNTI6MTY4MTIwOTgzNzMyMDozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Apr 2023 16:13:57
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.LY.V.CUSGRPNAME
**
* Subroutine Type : VERSION
* Attached to     : REDO.LY.CUSGROUP,INPUT
* Attached as     : Field DESCRIPTION as VALIDATION.RTN
* Primary Purpose : Validate if description or name inputted has been used in
*                   another customer group
*-----------------------------------------------------------------------------
* MODIFICATIONS HISTORY
*
* 22/01/13 - First Version.
*            ODR Reference: ODR-2011-06-0243.
*            Project: NCD Asociacion Popular de Ahorros y Prestamos (APAP)
*            Roberto Mondragon - TAM Latin America
*            rmondragon@temenos.com
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*11/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION           ++ TO +=, FM TO @FM
*11/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.CUSGROUP

    GOSUB INIT
    GOSUB PROCESS

RETURN

*----
INIT:
*----

    FN.REDO.LY.CUSGROUP = 'F.REDO.LY.CUSGROUP'
    F.REDO.LY.CUSGROUP = ''
    CALL OPF(FN.REDO.LY.CUSGROUP,F.REDO.LY.CUSGROUP)

RETURN

*-------
PROCESS:
*-------

    Y.DESC.NAME = COMI

    SEL.CMD = 'SELECT ':FN.REDO.LY.CUSGROUP

    SEL.CMD.ERR = ''
    CALL EB.READLIST(SEL.CMD,SEL.CMD.LIST,'',ID.CNT,SEL.CMD.ERR)

    ID.CNT.LOOP = 1
    LOOP
    WHILE ID.CNT.LOOP LE ID.CNT
        ID.CUSGRP = FIELD(SEL.CMD.LIST,@FM,ID.CNT.LOOP)
        R.REDO.LY.CUSGROUP = ''; CG.ERR = ''
        CALL F.READ(FN.REDO.LY.CUSGROUP,ID.CUSGRP,R.REDO.LY.CUSGROUP,F.REDO.LY.CUSGROUP,CG.ERR)
        IF R.REDO.LY.CUSGROUP THEN
            Y.CUSGROUP.DESC = R.REDO.LY.CUSGROUP<REDO.CUSGROUP.DESCRIPTION>
            IF Y.DESC.NAME EQ Y.CUSGROUP.DESC AND ID.CUSGRP NE ID.NEW THEN
                AF = REDO.CUSGROUP.DESCRIPTION
                ETEXT = 'EB-REDO.LY.V.CUSGRPNAME'
                CALL STORE.END.ERROR
                ID.CNT.LOOP = ID.CNT
            END
        END
        ID.CNT.LOOP += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT

RETURN

END
