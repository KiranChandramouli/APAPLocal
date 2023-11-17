* @ValidationCode : MjotMTYxNzE5MTEyMTpDcDEyNTI6MTY4Mzg5MjYxNjM0NzpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 May 2023 17:26:56
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------------
* Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*06/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*06/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.FT.TT.TRANSACTION.ID
    $INSERT I_EQUATE
    $INSERT I_COMMON
 
* $INSERT I_F.REDO.CREATE.ARRANGEMENT

    $INSERT I_F.REDO.FT.TT.TRANSACTION
* $INSERT I_System


* FN.REDO.CREATE.ARRANGEMENT = "F.REDO.CREATE.ARRANGEMENT"
* F.REDO.CREATE.ARRANGEMENT = ""
* CALL OPF(FN.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT)

    FN.REDO.FT.TT.TRANSACTION.NAU = "F.REDO.FT.TT.TRANSACTION$NAU"
    F.REDO.FT.TT.TRANSACTION.NAU = ""
    CALL OPF(FN.REDO.FT.TT.TRANSACTION.NAU,F.REDO.FT.TT.TRANSACTION.NAU)

* IF V$FUNCTION EQ 'I' THEN

*     Y.TEMP.ID = System.getVariable("CURRENT.Template.ID")
*     IF Y.TEMP.ID EQ "" THEN
*         RETURN
*     END

*     CALL F.READ(FN.REDO.CREATE.ARRANGEMENT,Y.TEMP.ID,R.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT,ARR.ERR)
*     STATUS.DISB = R.REDO.CREATE.ARRANGEMENT<REDO.FC.STATUS.DISB>

*     IF R.REDO.CREATE.ARRANGEMENT AND (STATUS.DISB = "" OR STATUS.DISB EQ "P" OR STATUS.DISB = "AP" OR STATUS.DISB = "D") THEN
*         INP = R.REDO.CREATE.ARRANGEMENT<REDO.FC.INPUTTER>
*         INP_USER = FIELD(INP, "_", 2)

*         IF INP_USER EQ OPERATOR THEN
*             E = "EB-LOAN.CREATED.BY.SAME.INPUTTER"
*         END
*    END

* END
* ELSE
    IF V$FUNCTION EQ 'A' THEN

        CALL F.READ(FN.REDO.FT.TT.TRANSACTION.NAU, COMI, R.REDO.FT.TT.TR.NAU, F.REDO.FT.TT.TRANSACTION.NAU, NAU.ERR)

        IF R.REDO.FT.TT.TR.NAU THEN
            CUR.APP.VER = FIELD(R.REDO.FT.TT.TR.NAU<FT.TN.L.ACTUAL.VERSIO>, ",",2)
            T.PGM.VER = FIELD(PGM.VERSION,",",2)

            IF T.PGM.VER NE CUR.APP.VER THEN
                RETURN
            END

            INP = R.REDO.FT.TT.TR.NAU<FT.TN.INPUTTER>
            INP_USER = FIELD(INP, "_", 2)

            IF INP_USER EQ OPERATOR THEN
                E = "EB-SAME.INPUTTER.AUTHORISER"
            END

        END
    END
END
