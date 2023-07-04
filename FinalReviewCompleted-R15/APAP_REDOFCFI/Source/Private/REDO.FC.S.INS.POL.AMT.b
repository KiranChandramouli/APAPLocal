* @ValidationCode : Mjo1NzMxMDE5NjU6Q3AxMjUyOjE2ODA2MDcxMjk0NjM6SVRTUzotMTotMTotMTE6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 04 Apr 2023 16:48:49
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -11
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FC.S.INS.POL.AMT
*-----------------------------------------------------------------------------
* Developer    : Luis Fernando Pazmino (lpazminodiaz@temenos.com)
* Date         : 16.06.2011
* Description  : Validation routine with calculates the Total Insurance Amount
*                based on the Monthly Amount and Extra Amount
*                (activated by a hotfield)
*-----------------------------------------------------------------------------
* Modification History:
*
* Version   Date            Who               Reference      Description
* 1.0       15.06.2011      lpazmino          CR.180         Initial version
* 1.1       27.01.2011      jvalarezoulloa    CR.180         amends
* 1.2       29.02.2011      jvalarezoulloa    CR.180         The field INS.TOTAL.PRE.AMT should not be calculated on base other fields

* 04-APRIL-2023      Harsha                R22 Auto Conversion  - VM to @VM , SM to @SM and I to I.VAR , J to J.VAR
* 04-APRIL-2023      Harsha                R22 Manual Conversion - No changes 
*----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Input/Output: N/A
* Dependencies: N/A
*-----------------------------------------------------------------------------

* <region name="INCLUDES">
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
* </region>

    GOSUB PROCESS

RETURN

* <region name="PROCESS">
PROCESS:
*Y.NUM.INS = DCOUNT(R.NEW(REDO.FC.POLICY.NUMBER),VM)
    Y.NUM.INS = DCOUNT(R.NEW(REDO.FC.INS.POLICY.TYPE),@VM)
    FOR I.VAR = 1 TO Y.NUM.INS
        Y.NUM.POL.AMT = DCOUNT(R.NEW(REDO.FC.INS.MON.POL.AMT)<1,I.VAR>,@SM)
        Y.TOT.PREM.AMT = 0
* INS.MON.POL.AMT is mandatory when Management type is eq Incluir en Cuota
        IF R.NEW(REDO.FC.INS.MON.POL.AMT)<1,I.VAR> EQ '' AND R.NEW (REDO.FC.INS.MANAGEM.TYPE)<1,I.VAR> EQ 'INCLUIR EN CUOTA' THEN
            AF = REDO.FC.INS.MON.POL.AMT
            AV = I.VAR
            ETEXT  = 'EB-FC-MANDOTORY.FIELD'
            CALL STORE.END.ERROR
        END
        FOR J.VAR = 1 TO Y.NUM.POL.AMT

            Y.INS.EXTRA.AMT = R.NEW(REDO.FC.INS.EXTRA.AMT)<1,I.VAR,J.VAR>
            IF R.NEW(REDO.FC.INS.MON.POL.AMT)<1,I.VAR,J.VAR> EQ '' AND R.NEW (REDO.FC.INS.MANAGEM.TYPE)<1,I.VAR> EQ 'INCLUIR EN CUOTA' THEN
                AF = REDO.FC.INS.MON.POL.AMT
                AV = I.VAR
                AS = J.VAR
                ETEXT  = 'EB-FC-MANDOTORY.FIELD'
                CALL STORE.END.ERROR
            END
            Y.INS.MON.POL.AMT = R.NEW(REDO.FC.INS.MON.POL.AMT)<1,I.VAR,J.VAR>

            R.NEW(REDO.FC.INS.TOT.PREM.AMT)<1,I.VAR,J.VAR> = Y.INS.MON.POL.AMT + Y.INS.EXTRA.AMT
* JV 29FEB2012     Y.TOT.PREM.AMT += R.NEW(REDO.FC.INS.TOT.PREM.AMT)<1,I,J> JV 29FEB2012
        NEXT J.VAR

*  JV 29FEB2012  R.NEW(REDO.FC.INS.TOTAL.PREM.AMT)<1,I> = Y.TOT.PREM.AMT
    NEXT I.VAR

RETURN
* </region>
END
