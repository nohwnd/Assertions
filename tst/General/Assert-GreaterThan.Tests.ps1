﻿InModuleScope -ModuleName Assert {
    Describe "Assert-GreaterThan" {
        Context "Comparing strings" {
            It "Passes when actual is greater than expected" {
                "z" | Assert-GreaterThan "a"
            }

            It "Fails when actual is equal to expected" {
                { "a" | Assert-GreaterThan "a" } | Verify-AssertionFailed
            }

            It "Fails when actual is lower than expected" {
                { "a" | Assert-GreaterThan "z" } | Verify-AssertionFailed
            }
        }

        Context "Comparing integers" {
            It "Passes when expected is greater than actual" {
                2 | Assert-GreaterThan 1
            }

            It "Fails when actual is equal to expected" {
                { 1 | Assert-GreaterThan 1 } | Verify-AssertionFailed
            }

            It "Fails when actual is lower than expected" {
                { 1 | Assert-GreaterThan 9 } | Verify-AssertionFailed
            }
        }

        Context "Comparing doubles" {
            It "Passes when expected is greater than actual" {
                .2 | Assert-GreaterThan .1
            }

            It "Fails when actual is equal to expected" {
                { .1 | Assert-GreaterThan .1 } | Verify-AssertionFailed
            }

            It "Fails when actual is lower than expected" {
                { .1 | Assert-GreaterThan .9 } | Verify-AssertionFailed
            }
        }

        Context "Comparing decimals" {
            It "Passes when expected is greater than actual" {
                2D | Assert-GreaterThan 1D
            }

            It "Fails when actual is equal to expected" {
                { 1D | Assert-GreaterThan 1D } | Verify-AssertionFailed
            }

            It "Fails when actual is lower than expected" {
                { 1D | Assert-GreaterThan 9D } | Verify-AssertionFailed
            }
        }

        Context "Comparing objects" {
            It "Fails when two objects are the same" {
                $object = New-Object -TypeName PsObject -Property @{ Name = "Jakub" }
                { $object | Assert-GreaterThan $object } | Verify-AssertionFailed
            }

            It "Fails when two objects are not comparable" {
                $object = New-Object -TypeName PsObject -Property @{ Name = "Jakub" }
                $object1 = New-Object -TypeName PsObject -Property @{ Name = "Jakub" }
                $err = { $object | Assert-GreaterThan $object1 } | Verify-Throw
                $err.Exception | Verify-Type ([System.Management.Automation.ExtendedTypeSystemException])
            }
        }

        It "Fails for array input even if the last item is greater than then expected value" {
             $err = {  1,2,3,4 | Assert-GreaterThan 3 } | Verify-Throw
             $err.Exception | Verify-Type ([System.Management.Automation.RuntimeException])
        }

        It "Fails with custom message" {
             $err = { 2 | Assert-GreaterThan 3 -CustomMessage "<actual> is not greater than <expected>" } | Verify-AssertionFailed
             $err.Exception.Message | Verify-Equal "2 is not greater than 3"
        }

        Context "Validate messages" {
            It "Given two values '<expected>' and '<actual>' it returns expected message '<message>'" -TestCases @(
                @{ Expected = "z" ; Actual = "a" ; Message = "Expected string 'a' to be greater than string 'z', but it was not."},
                @{ Expected = 10.1 ; Actual = 1.1 ; Message = "Expected double '1.1' to be greater than double '10.1', but it was not."},
                @{ Expected = 10.1D ; Actual = 1.1D ; Message = "Expected decimal '1.1' to be greater than decimal '10.1', but it was not."}
            ) {
                param($Expected, $Actual, $Message)
                $error = { Assert-GreaterThan -Actual $Actual -Expected $Expected } | Verify-AssertionFailed
                $error.Exception.Message | Verify-Equal $Message
            }
        }

        It "Returns the value on output" {
            $expected = 1
            $expected | Assert-GreaterThan 0 | Verify-Equal $expected
        }

        It "Can be called with positional parameters" {
            { Assert-GreaterThan 2 1 } | Verify-AssertionFailed
        }

        It "Given collection to Expected it throws" {
            $error = { "dummy" | Assert-GreaterThan @() } | Verify-Throw
            $error.Exception | Verify-Type ([ArgumentException])
        }
    }
}