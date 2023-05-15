* @ValidationCode : Mjo5NzM2NTkyNzU6Q3AxMjUyOjE2ODIwNzgwMDI0NTc6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 21 Apr 2023 17:23:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.MOVERENAMEFILE.TOHIST.DD

***-------*******-------*******-------*******-------*******-------*******-------*********-------**********-------******

* Descripcion: Duplica archivo procesado con sobreescritura en nueva ruta, renombra y elimina archivo en ruta original.
* Atachado/Disponible en: Batch de Servicio BNK/REDO.VP.DD.SERVICE
* Requerimiento: CN009103

***-------*******-------*******-------*******-------*******-------*******-------*********-------**********-------******

*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE             WHO              REFERENCE               DESCRIPTION

* 21-APR-2023  Conversion tool      R22 Auto conversion       BP is removed in Insert File
* 21-APR-2023    Narmadha V          R22 Manual Conversion    No Changes
*-----------------------------------------------------------------------------
    $INSERT I_F.DATES ;*R22 Auto conversion - START
    $INSERT I_F.REDO.VISION.PLUS.PARAM ;*R22 Auto conversion - END

* Open tables
    FN.REDO.VISION.PLUS.PARAM = "F.REDO.VISION.PLUS.PARAM"
    F.REDO.VISION.PLUS.PARAM= ""
    CALL OPF(FN.REDO.VISION.PLUS.PARAM,F.REDO.VISION.PLUS.PARAM)


    CALL CACHE.READ(FN.REDO.VISION.PLUS.PARAM, "SYSTEM", R.VER.ARR, VER.ARR.ERR) ;*R22 Auto conversion

* Get current date time in format YYYY.MM.DD.HHSS
    Y.DATE=OCONV(DATE(),"D-")
    Y.DATE=Y.DATE[9,2]:Y.DATE[1,2]:Y.DATE[4,2]
    Y.DATETIME.FORMAT=OCONV(ICONV(Y.DATE[1,6],"D2/"),'D4Y'):Y.DATE[3,4]:TIMEDATE()[1,2]:TIMEDATE()[4,2]
    Y.DD.FILENAME= R.VER.ARR<VP.PARAM.DD.FILE.NAME>
    Y.DD.FILEPATH= R.VER.ARR<VP.PARAM.DD.FILE.PATH>
    Y.DD.FILENAME.NEW.ID=Y.DD.FILENAME:".":Y.DATETIME.FORMAT

* Command that copy file, rename it with new ID and delete it from source
    Y.COMMAND = 'COPY FROM ':Y.DD.FILEPATH: ' TO ../interface/DD/DD_BACKUP ' :Y.DD.FILENAME: ',':Y.DD.FILENAME.NEW.ID : ' OVERWRITING DELETING'

    EXECUTE Y.COMMAND

RETURN

END
